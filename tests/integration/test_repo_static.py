from pathlib import Path
import sys
import yaml

ROOT = Path(__file__).resolve().parents[2]
compose_path = ROOT / "docker-compose.yml"

def fail(msg):
    print(f"[FAIL] {msg}")
    return 1

def ok(msg):
    print(f"[PASS] {msg}")
    return 0

errors = 0
required_files = [
    "README.md", "docker-compose.yml",
    "challenge-osint/Dockerfile", "challenge-osint/images/launch-day.jpg",
    "challenge-web/Dockerfile", "challenge-web/app.py",
    "challenge-linux/Dockerfile",
    "gateway-web/nginx.conf", "gateway-ssh/nginx.conf",
]
for rel in required_files:
    if (ROOT / rel).exists(): ok(f"Required file exists: {rel}")
    else: errors += fail(f"Missing required file: {rel}")

compose = yaml.safe_load(compose_path.read_text(encoding="utf-8"))
services = compose.get("services", {})
expected_services = {"ctfd","mariadb","challenge-osint","challenge-web","challenge-linux","gateway-web","gateway-ssh"}
missing = expected_services - set(services)
if missing: errors += fail(f"Missing Compose services: {sorted(missing)}")
else: ok("Expected seven Compose services are defined")

if services.get("mariadb", {}).get("ports"):
    errors += fail("MariaDB must not publish a host port")
else: ok("MariaDB has no host port")

for s in ("challenge-web", "challenge-linux"):
    if services.get(s, {}).get("ports"):
        errors += fail(f"{s} must not publish directly to the host")
    else: ok(f"{s} has no direct host port")
    nets = services.get(s, {}).get("networks", [])
    if "control_net" in nets:
        errors += fail(f"{s} must not join control_net")
    else: ok(f"{s} is not attached to control_net")

for s in expected_services:
    cfg = services.get(s, {})
    if "mem_limit" not in cfg or "cpus" not in cfg:
        errors += fail(f"{s} is missing CPU or memory limit")
    else: ok(f"{s} has CPU and memory limits")

web_conf = (ROOT / "gateway-web/nginx.conf").read_text(encoding="utf-8")
ssh_conf = (ROOT / "gateway-ssh/nginx.conf").read_text(encoding="utf-8")
if "nightfall-challenge-web:5000" in web_conf: ok("Web gateway targets NF03 container")
else: errors += fail("Web gateway upstream mismatch")
if "nightfall-challenge-linux:22" in ssh_conf: ok("SSH gateway targets NF06 container")
else: errors += fail("SSH gateway upstream mismatch")

app_text = (ROOT / "challenge-web/app.py").read_text(encoding="utf-8")
if "INTENTIONAL CTF VULNERABILITY" in app_text and "assigned_incidents" in app_text:
    ok("NF03 intentional authorization flaw is documented in source")
else: errors += fail("NF03 intended authorization flaw marker missing")

nf04 = [
    ROOT / "challenge-forensics/nightfall_capture.pcapng",
    ROOT / "challenge-forensics/access.log",
]
if any(p.exists() for p in nf04): ok("Some NF04 artefact exists")
else: print("[BLOCKED] NF04 artefacts are absent from this snapshot")

if any(
    (ROOT / "challenge-crypto" / name).exists()
    for name in ("nightfall.enc", "keygen.txt")
):
    ok("Some NF05 artefact exists")
else: print("[BLOCKED] NF05 artefacts are absent from this snapshot")

linux_text = (ROOT / "challenge-linux/Dockerfile").read_text(encoding="utf-8")
if "sudo" in linux_text.lower() and "final_flag" in linux_text.lower():
    ok("NF06 source mentions intended privilege path/final flag")
else: print("[BLOCKED] NF06 Dockerfile is only a skeleton; designed privilege path/final flag not present")

if errors:
    print(f"\nStatic configuration result: FAIL ({errors} error(s))")
    sys.exit(1)
print("\nStatic configuration result: PASS with integration blockers noted above")
