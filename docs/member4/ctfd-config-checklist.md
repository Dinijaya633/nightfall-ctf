# CTFd Configuration Checklist

The repository contains the CTFd container, but challenge metadata/requirements are not versioned in this snapshot. Configure or verify these values in the authorized CTFd instance and capture screenshots as evidence.

| Stage | Points | Requirement | Hint 1 penalty | Hint 2 penalty |
|---|---:|---|---:|---:|
| NF01 | 100 | None | 10 | 15 |
| NF02 | 125 | NF01 | 10 | 20 |
| NF03 | 175 | NF02 | 15 | 25 |
| NF04 | 200 | NF03 | 15 | 30 |
| NF05 | 275 | NF04 | 20 | 40 |
| NF06 | 350 | NF05 | 25 | 50 |

## Member 4 evidence to capture

- NF02 is locked before NF01 and unlocked only after NF01 is solved.
- The same chain continues NF02 → NF03 → NF04 → NF05 → NF06.
- Correct flag is accepted; wrong case, wrong stage and modified flag are rejected.
- Scores and hint penalties match this table.
- Public source contains no real event flags or organizer credentials.
