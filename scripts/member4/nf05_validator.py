from pathlib import Path
import argparse
import hashlib
import json
from cryptography.hazmat.primitives.ciphers.aead import AESGCM

parser = argparse.ArgumentParser()
parser.add_argument("--seed", required=True)
parser.add_argument("--date", required=True)
parser.add_argument("--file", default="challenge-crypto/nightfall.enc")
args = parser.parse_args()

data = Path(args.file).read_bytes()

if len(data) < 29:
    raise SystemExit("[FAIL] Encrypted file is too small")

nonce = data[:12]
ciphertext_and_tag = data[12:]

key = hashlib.sha256(f"{args.seed}_{args.date}".encode("utf-8")).digest()

try:
    plaintext = AESGCM(key).decrypt(nonce, ciphertext_and_tag, None)
    obj = json.loads(plaintext.decode("utf-8"))
except Exception:
    raise SystemExit("[FAIL] AES-GCM authentication/decryption failed")

required = {"flag", "ssh"}
if not required.issubset(obj):
    raise SystemExit("[FAIL] Decrypted JSON is missing required fields")

print("[PASS] AES-GCM decryption succeeded")
print("[PASS] JSON structure validated")
print("[PASS] NF05 hand-off data is present")
