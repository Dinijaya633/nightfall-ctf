from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[2]
SKIP_DIRS = {".git", "docs", "tests"}
text_exts = {".py", ".yml", ".yaml", ".md", ".txt", ".html", ".js", ".env", ".conf"}
patterns = [
    ("CTF flag literal", re.compile(r"NIGHTFALL\{[^}\n]+\}")),
    ("hard-coded Flask secret", re.compile(r"secret_key\s*=\s*[\"'][^\"']+[\"']")),
    ("hard-coded password field", re.compile(r"[\"']password[\"']\s*:\s*[\"'][^\"']+[\"']")),
    ("Dockerfile chpasswd secret", re.compile(r"echo\s+[\"'][^\"']+:[^\"']+[\"']\s*\|\s*chpasswd")),
    ("Compose DB password", re.compile(r"(?:MYSQL_ROOT_PASSWORD|MYSQL_PASSWORD|DATABASE_URL)\s*=?.*?(?:password|://)[^\s]*", re.I)),
]
findings = []
for p in ROOT.rglob("*"):
    if not p.is_file():
        continue
    if p.suffix.lower() not in text_exts and p.name not in {"Dockerfile"}:
        continue
    if any(part in SKIP_DIRS for part in p.relative_to(ROOT).parts):
        continue
    try:
        text = p.read_text(encoding="utf-8", errors="ignore")
    except Exception:
        continue
    for label, rx in patterns:
        for m in rx.finditer(text):
            line = text.count("\n", 0, m.start()) + 1
            findings.append((label, str(p.relative_to(ROOT)), line))

if findings:
    print("[FAIL] Potential public secret exposure detected:")
    for label, path, line in findings:
        print(f"  - {label}: {path}:{line}")
    print("\nDo not publish event secrets. Move/replace/rotate them and rerun this test.")
    sys.exit(1)

print("[PASS] No configured secret patterns were found in public source")
