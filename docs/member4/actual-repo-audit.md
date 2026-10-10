# Current Repository Integration Audit

Audit target: uploaded `nightfall-ctf-main` snapshot.

## Confirmed implementation

- `docker-compose.yml` defines CTFd, MariaDB, OSINT, web challenge, Linux challenge, web gateway and SSH gateway.
- MariaDB is not published to a host port.
- `challenge-web` and `challenge-linux` are not directly published to host ports; gateways publish 8081 and 2222.
- NF03 contains the intentionally missing object-level authorization check required by the design.
- NF01/NF02 public site contains the NIGHTFALL/developer/image clues and includes `launch-day.jpg`.
- CPU and memory limits are present for Compose services.

## Release blockers / discrepancies found

| Defect | Severity | Finding | Required action |
|---|---|---|---|
| D001 | Critical | Real-looking CTF/control secrets are hard-coded in public source, including an NF03 flag, challenge credentials, Flask session key and DB passwords. | Move event secrets out of public source, rotate before use, and rerun secret scan. Coordinate code changes with owners. |
| D002 | High | NF04 artefacts (`nightfall_capture.pcapng`, `access.log`, SHA-256 manifest) are absent. | Member 3 must add/hand over approved NF04 artefacts. |
| D003 | High | NF05 artefacts (`nightfall.enc`, `keygen.txt`, solver/dependency material) are absent. | Member 3 must add/hand over approved NF05 artefacts. |
| D004 | High | NF06 container is only an SSH user skeleton; designed sudo/writable-helper path and final flag are not implemented. | Member 3 must complete NF06 and provide reset/solution evidence. |
| D005 | Medium | CTFd challenge requirements/scores/hints/flags are not versioned in this repository snapshot, so T03/T04 cannot be verified from source. | Configure in CTFd and capture/export approved evidence. |
| D006 | Medium | Current Compose publishes OSINT on host TCP 8082, while the design report described file challenges via CTFd and participant ports 8000/8081/2222. | Treat as a documented implementation change or align implementation with approved design. |
| D007 | Low | Root README says “all six services,” but Compose currently defines seven services and the service table omits the OSINT service. | Correct documentation before final submission. |
| D008 | Medium | `challenge_front_backup.json` records an older `Internal=false` network state, while current README requires `challenge_front=true` (internal). | Do not use the backup as current evidence; verify the live network and remove/label stale evidence. |
| D009 | Medium | Existing `.gitignore` does not ignore `.env`, secret directories, CTFd exports or database backups. | Added safe ignore patterns in this Member 4 patch. |

## Current testing status

- T01–T04: not executed here against a live CTFd instance.
- T05: partial implementation present; steganographic payload was not executed in this audit environment.
- T06/T07: code path exists; live container test still required.
- T08/T09: BLOCKED because NF04/NF05 files are absent.
- T10: BLOCKED because NF06 designed privilege path is absent.
- T11/T12: static configuration looks directionally correct, but live Docker tests are required.
- T13/T14/T16: NOT RUN; live environment required.
- T15: BLOCKED by D002–D004.
