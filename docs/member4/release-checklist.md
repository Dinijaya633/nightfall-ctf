# Integration Gates / Release Checklist

## Content gate
- [ ] Every stage has scenario, objective, task, tools, dependency, solution path, flag logic, hints and reset/recovery.

## Dependency gate
- [ ] NF01 output exactly matches NF02 input.
- [ ] NF02 output exactly matches NF03 input.
- [ ] NF03 output exactly matches NF04 input.
- [ ] NF04 output exactly matches NF05 input.
- [ ] NF05 output exactly matches NF06 input.
- [ ] A fresh tester can recover each hand-off.

## Validation gate
- [ ] Valid flag accepted.
- [ ] Wrong-case/modified flag rejected.
- [ ] Wrong-stage flag rejected.
- [ ] Real proof values are not exposed in public source.

## Isolation gate
- [ ] MariaDB has no host port.
- [ ] NF03/NF06 challenge containers have no direct host ports.
- [ ] Challenge containers are not connected to `control_net`.
- [ ] `challenge_front` is actually created as an internal Docker network.
- [ ] No Docker socket or unintended host bind mount is present in challenge containers.
- [ ] NF06 is not privileged.

## Recovery gate
- [ ] Web challenge restores clean state.
- [ ] Linux challenge restores clean state.
- [ ] Downloadable artefacts match approved hashes.
- [ ] CTFd/database backup restore is rehearsed.

## Documentation gate
- [ ] Stage names, scores, ports, filenames and hint penalties are consistent in code/report/slides.
- [ ] Any design change (for example OSINT published on TCP 8082) is documented.
- [ ] README service count matches Compose service count.
