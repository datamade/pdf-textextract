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
