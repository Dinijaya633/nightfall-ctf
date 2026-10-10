import csv
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[2]
path = ROOT / "docs" / "member4" / "integration-manifest.csv"
expected = ["NF01", "NF02", "NF03", "NF04", "NF05", "NF06"]
expected_requires = {"NF01":"", "NF02":"NF01", "NF03":"NF02", "NF04":"NF03", "NF05":"NF04", "NF06":"NF05"}
expected_scores = {"NF01":"100", "NF02":"125", "NF03":"175", "NF04":"200", "NF05":"275", "NF06":"350"}

def fail(msg):
    print(f"[FAIL] {msg}")
    raise SystemExit(1)

with path.open(newline="", encoding="utf-8") as f:
    rows = list(csv.DictReader(f))

if [r["stage"] for r in rows] != expected:
    fail("Stage order must be NF01 -> NF06")

for r in rows:
    stage = r["stage"]
    if r["requires"] != expected_requires[stage]:
        fail(f"{stage}: prerequisite mismatch")
    if r["score"] != expected_scores[stage]:
        fail(f"{stage}: score mismatch")
    if not r["output"].strip():
        fail(f"{stage}: missing hand-off output")

print("[PASS] Six-stage manifest is present")
print("[PASS] Prerequisite chain is consistent")
print("[PASS] Scores match the approved NIGHTFALL design")
