## Firefox can now edit PDFs

For signing, etc., can use Firefox instead of Adobe Acrobat.
## GhostScript `gs` to reduce PDF size

Brought my PDF size from 106 MB to 800 KB.
```sh
gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 -dPDFSETTINGS=/printer -dNOPAUSE -dQUIET -dBATCH -sOutputFile=compressed.pdf ~/Downloads/original.pdf
```