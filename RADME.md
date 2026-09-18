# Operation NIGHTFALL – The Cygnus Labs Breach

## Project Setup

This project uses Docker Compose and CTFd.

### Services

| Service        | Purpose             |          Port |
| -------------- | ------------------- | ------------: |
| CTFd           | CTF platform        |          8000 |
| Web Gateway    | NF03 access         |          8081 |
| SSH Gateway    | NF06 access         |          2222 |
| NF03 Challenge | Web challenge       | Internal 5000 |
| NF06 Challenge | Linux/SSH challenge |   Internal 22 |
| MariaDB        | CTFd database       | Internal 3306 |

## 1. Create Docker Networks

Run these commands before starting the project:

```powershell
docker network create --internal control_net
docker network create --internal challenge_front
docker network create ctfd_front
docker network create nightfall_ingress
```

If a network already exists, Docker will report that it already exists. Do not recreate or delete it unnecessarily.

Check:

```powershell
docker network inspect challenge_front --format "{{.Internal}}"
docker network inspect control_net --format "{{.Internal}}"
docker network inspect nightfall_ingress --format "{{.Internal}}"
```

Expected:

```text
challenge_front = true
control_net = true
nightfall_ingress = false
```

## 2. Start the Project

```powershell
docker compose up -d --build
```

Check:

```powershell
docker compose ps
```

All six services should be running.

## 3. Access the System

CTFd:

http://localhost:8000

NF03 Web Challenge:

http://localhost:8081

NF06 SSH Gateway:

localhost:2222

## 4. Important Rules

Do not add challenge containers to `control_net`.

Do not expose MariaDB using a host `ports:` section.

Do not expose NF03 or NF06 directly to the host.

The intended external access is through:

* Web Gateway → NF03
* SSH Gateway → NF06

## 5. Current Platform Architecture

CTFd and MariaDB operate on the control network.

Challenge containers operate on the isolated challenge network.

Gateway containers connect the external ingress network to the challenge network.

The challenge containers must not have direct Internet access.

The challenge containers must not directly access CTFd or MariaDB.

## 6. Team Work

Challenge team:

* Configure and test NF01–NF06
* Add flags
* Add hints
* Add solutions
* Configure requirements
* Test intended solve paths

Documentation/testing team:

* Perform final validation
* Collect screenshots
* Document deployment
* Document reset procedure
* Prepare report evidence

Platform team:

* Maintain Docker Compose
* Maintain network isolation
* Maintain gateway configuration
* Maintain resource limits

## 7. Before Changing Docker Configuration

Please tell the platform/infrastructure person before:

* changing Docker networks
* changing published ports
* modifying gateway configuration
* connecting challenge containers to control_net
* exposing MariaDB
* changing resource limits
* deleting Docker volumes

The infrastructure is intentionally isolated for the CTF security design.
