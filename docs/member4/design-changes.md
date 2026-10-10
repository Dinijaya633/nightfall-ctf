# NIGHTFALL Design Changes Record

## Purpose
This file records implementation changes from the Assignment 01 approved design and the technical reason for each change.

## DC01 - NF01 host access moved behind gateway-web

**Original design**
- NF01 (`challenge-osint`) was intended to publish host port `8082` directly to container port `80`.

**Problem found**
- The challenge container was attached only to the internal `challenge_front` network.
- Docker configuration showed the requested port mapping, but the runtime did not publish host port `8082`.
- `localhost:8082` was therefore unreachable.

**Implemented change**
- Removed direct host publishing from `challenge-osint`.
- Added port `8082` to `gateway-web`.
- Added an Nginx server on port `8082` that proxies requests to `nightfall-challenge-osint:80`.
- Kept NF03 on gateway port `8081`.

**Technical justification**
- This keeps the challenge container on the isolated internal challenge network.
- Only the gateway is exposed to the host.
- The change preserves the intended network isolation while restoring participant access to NF01.

**Validation**
- `http://localhost:8082` returned HTTP 200 for NF01.
- `http://localhost:8081` still returned HTTP 200 for NF03 after the change.
- Defect D006 was retested and closed.

**Evidence**
- `evidence/D006-NF01-gateway-fixed.png`
- `evidence/D006-gateway-regression-pass.png`

## Final review
Additional implementation deviations, if found during the final end-to-end test, must be recorded here before release.
