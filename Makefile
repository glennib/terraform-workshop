
.PHONY: help compile compile-handout present present-without-notes terraform-concepts

help: ## Display this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

compile: main.pdf ## Compile the presentation

compile-handout: main-handout.pdf ## Compile the handout version of the presentation

present: main.pdf main.pdfpc ## Run presentation
	pdfpc main.pdf

present-without-notes: main.pdf ## Run presentation without notes
	pdfpc main.pdf

terraform-concepts: assets/terraform-concepts.pdf ## Convert the pdf of figures to svg files
	./scripts/pdf-to-svgs.sh assets/terraform-concepts.pdf

main.pdf: main.typ
	typst compile main.typ

main.pdfpc: main.typ
	polylux2pdfpc main.typ

main-handout.typ: main.typ
	./scripts/handout.sh main.typ

main-handout.pdf: main-handout.typ
	typst compile main-handout.typ
