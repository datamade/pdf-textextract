# PDF Text Extraction, the simplistic and resilient way.

Extracting text from PDFs seems pretty simple until you try. Many (maybe most PDFs) are nice creatures and so wonderful tools like [pdftotext](https://en.wikipedia.org/wiki/Pdftotext) just work. If just have a few pdfs that you want to extract text from, you should start there.

But the PDF "format" is a vast and shadowy forest, and there are lots of PDFs where extracting the text by looking into the file is impossible or very difficult.

However, well formed PDFs can always be opened by PDF programs and have their contents rendered on a screen. And that's where we start in our approach to text extraction. 

1. Render the pages of a PDF as images.
2. Perform a little image processing to make those images more amenable to OCR.
3. OCR the individual images.
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

If you PDFs are in a directory called "~/lots_of_pdfs", you can adjust the `docker-compose.yml` like:

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

and you'll start processing the PDFs. When everything is done you'll have a lot of files in your output directory (by default `./texts`) that look like `d356e527274c55c51c8008af74dfd08ce3051710f336341556e3d1d4eb7c6cf2.json` and have contents like:

```json
{
    "filename": "6.pdf",
    "pages": [
        " \n\n \n\nWade L. Robison and Linda Reeser\nEthical Decision-Making in Social Work\n\nChapter 6\n\nJustice\n\nIntroduction\n1. Particular justice\n. The formal principle of justice\n. Substantive principles of justice\n. Using princ.."
    ]
}
```

The filename of the output files are based on hash of the original PDF filename. We do this because Make is a bit sensitive to forms of filenames and this just avoids a lot of complexity. 
