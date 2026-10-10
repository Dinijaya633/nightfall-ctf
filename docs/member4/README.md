# Member 4 – Integration, Testing & Documentation

This folder contains the Integration, Testing and Documentation work for **Operation NIGHTFALL – The Cygnus Labs Breach**.

Member 4 is responsible for:
- integration map and stage hand-offs;
- CTFd prerequisite/score/hint validation;
- positive, negative, isolation and recovery testing;
- release gates and defect tracking;
- risk analysis;
- documentation consistency and evidence collection.

## Current repository status

The current repository already contains working/planned implementation material for NF01/NF02 (OSINT/steganography hosting), NF03 (Flask web challenge), the Docker/CTFd platform, and an SSH container skeleton for NF06.

The current snapshot does **not** contain the NF04 evidence bundle or the NF05 crypto bundle/solver files, and the NF06 Dockerfile does not yet implement the designed sudo/writable-helper privilege path or final flag. Those items should remain owned by the challenge-design member, but Member 4 must record them as integration blockers until supplied.

## Run Member 4 checks

From the repository root:

```bash
python tests/integration/test_manifest.py
python tests/integration/test_repo_static.py
python tests/integration/test_secret_exposure.py
```

The secret exposure test is expected to **FAIL on the current snapshot** because the repository contains hard-coded challenge/control secrets. Do not change FAIL to PASS without fixing/rotating the values and retesting.

If the Docker lab is running:

```bash
bash scripts/smoke_test.sh
```

Use `test-results.csv` and `defect-log.csv` to record actual evidence. A planned test is not a PASS until it is executed.
