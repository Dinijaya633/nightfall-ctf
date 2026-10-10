# Master Testing and Validation Plan

| ID | Test | Method | Pass condition | Primary owner |
|---|---|---|---|---|
| T01 | CTFd availability | Open authorized host port 8000 | Login page loads and intended access policy is enforced | Member 1 |
| T02 | Account separation | Register/login participant and inspect permissions | Participant cannot use administrator functions | Member 4 |
| T03 | Prerequisite chain | Attempt each stage before/after its prerequisite | Locked before; available after valid previous-stage solve | Member 4 |
| T04 | Flag validation | Submit valid, modified, wrong-case and wrong-stage flags | Only configured exact flag is accepted | Member 4 |
| T05 | NF01/NF02 artefacts | Retrieve site/image and verify approved hashes/solve path | Intended clue and hand-off are recoverable | Member 2 |
| T06 | NF03 intended flaw | Use approved low-privilege lab account against target record | Intended object-level authorization flaw works only in challenge service | Member 2 |
| T07 | NF03 negative behavior | Invalid login and invalid record IDs | Authentication fails; invalid IDs do not leak stack traces/flags | Member 2 |
| T08 | NF04 evidence | Filter prepared capture and correlate supporting log | One unambiguous stream/log pair yields proof | Member 3 |
| T09 | NF05 solver | Run approved reference solver in bounded candidate set | Correct candidate decrypts within limit; wrong candidate fails integrity | Member 3 |
| T10 | NF06 capstone | Enumerate and use only intended container privilege path | Final flag reachable; unintended paths unavailable | Member 3 |
| T11 | Network isolation | Probe control DB/external destinations from challenge workloads | Control DB and unauthorized external networks unreachable | Member 1 |
| T12 | Resource limits | Apply bounded local load | Limits hold and CTFd remains responsive | Member 1 |
| T13 | Web reset | Modify allowed challenge state then restart/recreate | Approved initial state returns | Member 4 |
| T14 | Linux reset | Complete NF06 then destroy/recreate | Original low-privilege state and approved hashes return | Member 4 |
| T15 | End-to-end run | Fresh tester solves NF01 → NF06 | Every hand-off is sufficient; no organizer-only knowledge required | All members |
| T16 | Backup recovery | Restore CTFd/database backup in staging | Challenges, scores, hints and requirements return | Member 1 + Member 4 |

## Result rules

Use only: `PASS`, `FAIL`, `BLOCKED`, `NOT RUN`.

A test can be marked PASS only after execution. Record the commit hash and evidence file for every result.
