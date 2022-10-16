FROM python:3.10-slim-bullseye

RUN apt-get update && apt-get install --no-install-recommends -y \
  make \
  poppler-utils \
  tesseract-ocr \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY Makefile requirements.txt /app
COPY scripts/*.py scripts/

RUN pip install --no-cache-dir -r requirements.txt

CMD ["make"]
