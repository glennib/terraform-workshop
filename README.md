# source for terraform workshop

## looking for terraform template code?

[🔗](./terraform/) `cd terraform`

## dependencies

- compiling presentation
  - [`typst`] - `sudo snap install typst`
- converting PDF to SVGs (for figures)
  - [`pdfinfo`] - `sudo apt install poppler-utils`
  - [`pdf2svg`] - `sudo apt install pdf2svg`
- presentation tools
  - [`pdfpc`] - `sudo apt install pdf-presenter-console` - for displaying presentation pdf
  - [`polylux2pdfpc`] - `cargo install --git https://github.com/andreasKroepelin/polylux/ --branch release` - for extracting presentation notes


[`typst`]: https://github.com/typst/typst
[`pdfinfo`]: https://www.xpdfreader.com/pdfinfo-man.html
[`pdf2svg`]: https://github.com/dawbarton/pdf2svg
[`pdfpc`]: https://polylux.dev/book/external/pdfpc.html
[`polylux2pdfpc`]: https://polylux.dev/book/external/pdfpc.html#extracting-the-data--polylux2pdfpc

## compiling

```bash
make compile-handout        # Compile the handout version of the presentation
make compile                # Compile the presentation
make present                # Run presentation
make present-without-notes  # Run presentation without notes
make terraform-concepts     # Convert the pdf of figures to svg files
```
