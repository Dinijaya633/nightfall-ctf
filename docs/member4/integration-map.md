# Integration Map

| Stage | Title | Depends on | Required input | Intended hand-off | Score |
|---|---|---|---|---|---:|
| NF01 | Footprints in the Open | None | Public fictional site | Developer handle + launch-day image filename | 100 |
| NF02 | Picture Perfect Secret | NF01 | Developer handle + `launch-day.jpg` | Low-privilege account + portal route + incident reference family | 125 |
| NF03 | Forgotten Dev Portal | NF02 | Route/account/incident pattern | Evidence bundle + case ID + time window | 175 |
| NF04 | Packets Do Not Lie | NF03 | Case ID + time window | Archive seed + event date + encrypted-bundle filename | 200 |
| NF05 | Cipher in the Archive | NF04 | Archive seed/date/encrypted bundle | Container-only SSH credentials + host alias | 275 |
| NF06 | Root of the Breach | NF05 | Lab-only SSH credentials | Final master flag + complete attack-path explanation | 350 |

## Current implementation mapping

- NF01/NF02 content is hosted by `challenge-osint`; current Compose publishes it on host TCP 8082.
- NF03 is `challenge-web` behind `gateway-web` on host TCP 8081.
- NF06 is `challenge-linux` behind `gateway-ssh` on host TCP 2222, but the designed privilege-escalation challenge is not yet implemented in this snapshot.
- NF04 and NF05 implementation artefacts are not present in this snapshot.

## Integration rule

Every stage output must be sufficient for a fresh tester to begin the next stage without organizer-only knowledge. Any missing, ambiguous or circular hand-off blocks release.
