# PDF Text Extraction, the simplistic and resilient way.

Extracting text from PDFs seems pretty simple until you try. Most PDFs are happy little trees and so wonderful tools like [pdftotext](https://en.wikipedia.org/wiki/Pdftotext) just work. If just have a few pdfs that you want to extract text from, you should start there.

But the PDF "format" is a vast and shadowy forest, and there are lots of PDFs where extracting the text by looking into the file is impossible or very difficult.

However, well formed PDFs can always be opened by PDF programs and have their contents rendered on a screen. And that's where we start in our approach to text extraction. Here's what we do.

1. Render the pages of a PDF as images with [poppler-utils](https://en.m.wikipedia.org/wiki/Poppler_(software)).
2. Perform a little image processing, with [opencv](https://docs.opencv.org/), to make those images more amenable to OCR.
3. OCR the individual images using [tesseract](https://en.wikipedia.org/wiki/Tesseract_(software)).
4. Recombine the OCRed texts into a single file.

We perform these steps using [Make](https://en.wikipedia.org/wiki/Make_(software)) because it gives us easy parallelism and a nice way to restart processes if they get interrupted.

## How to use

The `docker-compose.yml` gives an example of how you might use this `pdf-textract` Docker container. The most important settings are the mount points

```yml
    volumes:
      # Set these to change where you are reading pdfs from and
      # writing processed json to
      - "./pdfs:/app/input"
      - "./intermediate:/app/intermediate"
      - "./texts:/app/output"
```

If your PDFs are in a directory called `~/lots_of_pdfs`, you can adjust the `docker-compose.yml` like:

```yml
    volumes:
      # Set these to change where you are reading pdfs from and
      # writing processed json to
      - "~/lots_of_pdfs:/app/input"
      - "./intermediate:/app/intermediate"
      - "./texts:/app/output"
```

Once you've got that set the way you want it, you run

```bash
docker-compose up
```

and you'll start processing the PDFs. 

When everything is done you'll have a lot of files in your output directory (by default `./texts`) that look like `d356e527274c55c51c8008af74dfd08ce3051710f336341556e3d1d4eb7c6cf2.json` and have contents like:

```json
{
    "filename": "6.pdf",
    "pages": [
        " \n\n \n\nWade L. Robison and Linda Reeser\nEthical Decision-Making in Social Work\n\nChapter 6\n\nJustice\n\nIntroduction\n1. Particular justice\n. The formal principle of justice\n. Substantive principles of justice\n. Using princ.."
    ]
}
```

The names of the output files are based on a hash of the original PDF filename. We do this because Make is a bit sensitive to forms of filenames and this just avoids a lot of complexity. 


## This repository

This repository contains the Makefile and Python scripts and a Dockerfile for building an image, as well as a github action to publish to [Github's contianer registry](https://github.com/datamade/pdf-textextract/pkgs/container/pdf-textextract).

## Funding
The open sourcing of this work was funded by Project Recognize. Funding for Project Recognize is provided by an R01 grant from the National Institute on Alcohol Abuse and Alcoholism within the National Institutes of Health(NIH) under grant number [R01AA029076](https://reporter.nih.gov/search/fQ3qCVpYLkyVX-Y18Ku7eA/project-details/10700962). You can find out more at [ProjectRecognize.org](https://www.projectrecognize.org).
