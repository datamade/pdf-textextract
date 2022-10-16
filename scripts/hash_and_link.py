import sys
import csv
from pathlib import Path
import hashlib

outdir = Path(sys.argv[1])

reader = csv.reader(sys.stdin)

for filename in sys.stdin:
    in_path = Path(filename.strip()).resolve()
    m = hashlib.sha256()
    m.update(str(in_path).encode())
    out_path = outdir / m.hexdigest()
    if out_path.exists():
        if Path(out_path.readlink()) == in_path:
            continue
        # hash collisions should be very rare, but
        # let's deal with them
        else:
            i = 0
            while out_path.exists():
                m.update(str(i).encode())
                out_path = outdir / m.hexdigest()
                i += 1
    out_path.symlink_to(in_path)
