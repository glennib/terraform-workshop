# Source for Terraform workshop

## Dependencies

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
