# Documentation Control Inventory

## Canonical names
- Project: Operation NIGHTFALL – The Cygnus Labs Breach
- NF01: Footprints in the Open
- NF02: Picture Perfect Secret
- NF03: Forgotten Dev Portal
- NF04: Packets Do Not Lie
- NF05: Cipher in the Archive
- NF06: Root of the Breach

## Current repository ports
- CTFd: host TCP 8000
- NF03 gateway: host TCP 8081 → challenge TCP 5000
- NF06 gateway: host TCP 2222 → challenge TCP 22
- NF01/NF02 OSINT service: host TCP 8082 → container TCP 80 (current implementation change)
- MariaDB: internal TCP 3306 only

## Public flag format
`NIGHTFALL{S<stage>_<secret>}`

## Important planned artefact names
- `launch-day.jpg`
- `nightfall_capture.pcapng`
- `access.log`
- `nightfall.enc`
- `keygen.txt`
- `requirements.txt`

## Do not publish
- real event flags;
- organizer/admin passwords;
- NF05 hand-off SSH credentials;
- private solution sheets;
- `.env` values;
- CTFd/database backups containing secrets.
