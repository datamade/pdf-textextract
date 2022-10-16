import sys
import json
from pathlib import Path
import os

text_list = []
encoded_filename = sys.argv[1]
ocr_text_files = sorted(sys.argv[2:])

encoded_file = Path(os.environ['INTERMEDIATE_DIR']) / 'encoded_filenames') / encoded_filename
original_filename = encoded_file.readlink().name

for ocr_text_file in ocr_text_files:
    
    with Path(ocr_text_file).open() as f:
        text = f.read()

    text_list.append(text)

json.dump({'filename': original_filename,
           'pages': text_list}, sys.stdout, indent=4)
