// Get Polylux from the official package repository
#import "@preview/polylux:0.3.1": *
#import "@preview/cetz:0.2.2"
#import themes.simple: title-slide, centered-slide, focus-slide, slide, simple-theme
#import pdfpc : speaker-note

// Make the paper dimensions fit for a presentation and the text larger
#set page(paper: "presentation-16-9")
#set text(size: 20pt, lang: "nb")
#show link: t => [#set text(blue); #underline[#t]]

#show heading: set block(below: 1em)

// Use #polylux-slide to create a slide and style it using your favourite Typst functions
#title-slide[
  = Terraform

  Hva, hvorfor og hvordan

  #[
    #set text(size: 18pt)
    Workshop \@ Amedia
  ]

  #datetime(year: 2024, month: 5, day: 28).display()
]

#slide[
  #v(1fr)
  #grid(columns: (1fr, 1fr), [
    #show outline.entry: it => [
      #sym.bullet #h(0.2em) #it.element.body
    ]
    #outline(depth: 1, fill: none)
  ], align(horizon, image("assets/Terraform_Logo.svg", width: 100%)))
  #v(1fr)
]

#centered-slide[
  = Slik håndterer vi infrastruktur i skyen
]

#centered-slide[
  == ClickOps™

  _Den raskeste veien til mål_

  #link("assets/clickops.webm")[video]
]

#slide[
== CLI

_Presist, repeterbart_

```bash
gcloud --project='amedia-adp-test' pubsub \
  topics create 'my-topic' \
  --message-retention-duration=1d

gcloud --project='amedia-adp-test' pubsub \
  subscriptions create 'my-subscription' \
  --topic='my-topic'
```

#v(1fr)

#uncover(
  2,
)[
#link(
  "https://github.com/amedia/adp-content-metrics-publisher/blob/5f7620548ed3000935b42637b0716461ae74e6a2/infrastructure/create-infrastructure.sh",
)[`create-infrastructure.sh`]
]
]

#let steps_1 = cetz.canvas(
  {
    import cetz.draw: *

    let my_scale = 1.0

    set-style(
      fill: gray.lighten(70%), stroke: (thickness: my_scale * 2pt), radius: 0.7 * my_scale,
    )

    circle((0 * my_scale, 1 * my_scale), name: "a")
    circle((3 * my_scale, 3 * my_scale), name: "b")
    circle((6 * my_scale, 0 * my_scale), name: "c", fill: green.lighten(70%))

    set-style(
      mark: (end: ">", scale: 3 * my_scale), stroke: (thickness: 4pt * my_scale),
    )

    line("a", "b")
    line("b", "c")
  },
);
#let steps_2 = cetz.canvas(
  {
    import cetz.draw: *

    let my_scale = 1.0

    set-style(
      fill: red.lighten(70%), stroke: (thickness: my_scale * 2pt, dash: "dashed"), radius: 0.7 * my_scale,
    )

    circle(
      (0 * my_scale + 8 * my_scale, 1 * my_scale - 1.0 * my_scale), name: "a2", fill: gray.lighten(70%), stroke: (dash: "solid"),
    )
    circle(
      (3 * my_scale + 8 * my_scale, 3 * my_scale - 1.0 * my_scale), name: "b2",
    )
    content((), "?")
    circle(
      (6 * my_scale + 8 * my_scale, 0 * my_scale - 1.0 * my_scale), name: "c2",
    )
    content((), "?")

    set-style(fill: none, stroke: (dash: "solid"), radius: 0.7 * my_scale)

    circle((0 * my_scale, 1 * my_scale), name: "a", stroke: (dash: "dashed"))
    circle((3 * my_scale, 3 * my_scale), name: "b")
    circle((6 * my_scale, 0 * my_scale), name: "c", fill: green.lighten(90%))
    content((), ":(")

    set-style(
      mark: (end: ">", scale: 3 * my_scale), stroke: (thickness: 4pt * my_scale),
    )

    line("a2", "b2")
    line("b2", "c2")
  },
);

#slide[
  == Fellestrekk

  _ClickOps og CLI_

  - Sekvens av steg som forhåpentligvis tar deg til mål
  - Beskriver handlinger, ikke tilstand
  - Er ikke "idempotent"

  #v(1em)

  #only(1)[#steps_1]
  #only(2)[#steps_2]
]

#centered-slide[
  = Dette er Terraform

  infrastruktur som kode \
  _(infrastrucure as code, IaC)_
]

#slide[
== Man beskriver ønsket tilstand

#grid(columns: (1fr, 1fr), [
Jeg vil ha:

- Et pubsub topic som heter `my-fancy-topic`
- En subscription som heter `my-fancy-topic-subscription`
  - ack-deadline på 20 sekunder
  - pusher til et endepunkt
], [
#uncover(2)[
#set text(size: 13pt)
```hcl
resource "google_pubsub_topic" "the-topic" {
  name = "my-fancy-topic"
}

resource "google_pubsub_subscription" "the-subscription" {
  name = "my-fancy-topic-subscription"
  topic = google_pubsub_topic.the-topic.name
  ack_deadline_seconds = 20
  push_config {
    push_endpoint = "https://example.com/notify"
  }
}
```
]

])

]

#slide[
  #image("assets/terraform-concepts-1.svg", width: 100%)
]

#centered-slide[
  = Derfor er det lurt å bruke Terraform
]

#slide[
  == Å bruke Terraform er lurt fordi

  - koden _er_ infrastrukturen $==>$ "dokumentasjonen" vedlikeholdes automatisk
  - historikk ved hjelp av git
  - tjenestene blir mer reproduserbare

  #v(1fr)

  #uncover(2)[
    En tjeneste består av både kode _og_ infrastruktur
  ]
]

#centered-slide[
  = Slik fungerer det (_ish_)
]

#slide[
== Eksempel: Et pubsub topic og en subscription

#only((1, 4))[
```hcl
resource "google_pubsub_topic" "the-topic" {
  name = "my-fancy-topic"
}

resource "google_pubsub_subscription" "the-subscription" {
  name = "my-fancy-topic-subscription"
  topic = google_pubsub_topic.the-topic.name
  ack_deadline_seconds = 20
  push_config {
    push_endpoint = "https://my-endpoint.example.com/notify"
  }
  description = "Subscribes to id ${google_pubsub_topic.the-topic.id}"
}
```

]

// empty lines to make the code blocks the same height
#only(2)[
```hcl
resource "google_pubsub_topic" "the-topic" {
  name = "my-fancy-topic"
}










```

ressurstype, navn (scopet), argument
]

#only(3)[
```hcl
resource "google_pubsub_topic" "the-topic" {
  name = "my-fancy-topic"
}

resource "google_pubsub_subscription" "the-subscription" {

  topic = google_pubsub_topic.the-topic.name




  description = "Subscribes to id ${google_pubsub_topic.the-topic.id}"
}
```

referanse til argument og attributt
]

#v(1fr)
]

#slide[
  #image("assets/terraform-concepts-1.svg", width: 100%)
]

#slide[
#show heading: set block(below: 0.7em) // in this slide the default block is too large
== Prosessen i grove trekk

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  stroke: (x, y) => {
    if (x == 0) {
      (
        right: (dash: "dashed")
      )
    }
    else {
      none
    }
  },
  [
  - utvikleren endrer på en *konfigurasjon* (f.eks. legger til ressurser i `main.tf`)
  #uncover(
    "3-",
  )[
    - terraform sammenlikner konfigurasjonen med en *tilstand* og lager en *plan*
  ]
  #uncover("4-")[
    - terraform får tilgang til skyen ved hjelp av en *provider*
  ]
  #uncover("5-")[
    - ved hjelp av providerens API-er gjør terraform endringer i ressurser
  ]
  #uncover("6-")[
    - tilstanden er nå oppdatert slik at den stemmer med konfigurasjonen
  ]
  ], [
  #uncover("2-")[
  / konfigurasjon: filer som slutter med `.tf`
  ]
  #uncover("3-")[
  / tilstand: vanligvis `default.tfstate` -- lagret lokalt eller i en bøtte (en *backend*) --
    beskriver hvilke ressurser terraform tracker og tilstanden til disse ressursene
    -- holdes i synk ved hver `terraform plan/refresh`
  / plan: en sekvens av handlinger som utgjør en diff, og fører til at tilstanden er slik
    konfigurasjonen tilsier
  ]
  #uncover(
    "4-",
  )[
    / provider: en plugin som beskriver hvilke ressurser som er tilgjengelige, og hvordan de
      konfigureres
  ]
  ],
)
]

#centered-slide[
= Noen vanlige operasjoner

#sym.bullet legge til en ressurs #sym.bullet `count` og `for_each` #sym.bullet lage
en modul

Med demonstrasjon fra lokal kjøring av Terraform
]

#centered-slide[
== Legge til en ressurs
#speaker-note(
  ```md
  Lag en ny mappe med terraform-filer basert på privat tf test repo

  Lag en ny topic ressurs i `main.tf` og kjør `terraform init` og `terraform apply`

  Sjekk at ressursen er opprettet i skyen
  ```,
)
]

#centered-slide[
== Bruke `count` og `for_each`
#speaker-note(```md
    Legg til subscribers med `count` og deretter `for_each`
    ```)
]

#centered-slide[
== Lage en modul
#speaker-note(
  ```md
  Flytt disse ressursene til en modul og bruk modulen i `main.tf`, med variabler og outputs
  ```
)
]

#centered-slide[
  = Håndtering av «drift»

  Hva om noen tuller det til med ClickOps™?
]

#slide[
  #image("assets/terraform-concepts-2.svg", width: 100%)
]

#slide[
  == Noen har lagt til en ressurs med ClickOps™

  - Dette er helt OK, Terraform tracker ikke ressurser som ikke er i tilstanden, og
    vil derfor ikke gjøre noe med dem.
  - Om man ønsker å tracke dem med Terraform etter at de er opprettet, kan man
    importere dem.
]

#slide(image("assets/terraform-concepts-3.svg", width: 100%))

#slide[
+ Konfigurér ressursblokker som tilsvarer ressursene som allerede eksisterer
  ```hcl
  resource "google_pubsub_topic" "the-topic" { ... }
  ```

+ Importér de eksisterende ressursene
  ```bash
  terraform import google_pubsub_topic.the-topic projects/<project-id>/topics/<topic-id>
  ```

+ Se om konfigurasjonen matcher tilstanden
  ```bash
  terraform plan
  ```

+ Om konfigurasjonen matcher, vil Terraform ikke gjøre noen endringer. Om ikke, må
  konfigurasjonen tilpasses, eller så må man akseptere at tilstanden endres:
  ```bash
  terraform apply
  ```
]

#slide[
== Har man Terraformet noe som man ønsker å håndtere videre med ClickOps™?

- Da må man få Terraform til å "glemme" ressursen, og fjerne den fra
  konfigurasjonen.
]

#slide(image("assets/terraform-concepts-4.svg", width: 100%))

#slide[
+ Fjern ressursen fra konfigurasjonen
  ```hcl
  // fjern denne blokken
  resource "google_pubsub_topic" "the-topic" { ... }
  ```

+ "Glem" ressursen fra tilstanden
  ```bash
  terraform state rm google_pubsub_topic.the-topic
  ```

+ Se om konfigurasjonen matcher tilstanden
  ```bash
  terraform plan
  ```
  Planen skal ikke vise noen endringer.
]

#slide[
== Hva om man ønsker å terraforme ressursen, men ikke _alle_ attributtene?

+ Oppdater konfigurasjonen med en `lifecycle`-blokk som inneholder `ignore_changes`
  ```hcl
  resource "google_pubsub_topic" "the-topic" {
    name = "my-fancy-topic"
    lifecycle {
      ignore_changes = ["message_retention_duration"]
    }
  }
  ```

+ Sjekk at en ny plan ikke medfører endringer.
]

#slide[
== Jeg ønsker å endre navn på eller flytte en ressurskonfigurasjon

+ Flytt eller gi nytt navn til ressursen i konfigurasjonen
  ```hcl
  //                   endra fra "the-topic"
  resource "google_pubsub_topic" "hot-topic" {
    name = "my-fancy-topic"
  }
  ```

+ Flytt til riktig adresse i tilstanden
  ```bash
  terraform state mv \
    google_pubsub_topic.the-topic \
    google_pubsub_topic.hot-topic
  ```

+ Sjekk at en ny plan ikke medfører endringer.
]

#slide[
== Jeg ønsker å flytte en frittstående ressurs inn i en modul

`terraform state mv` fungerer også mellom, inn, og ut av moduler:

```bash
terraform state mv \
  google_pubsub_topic.the-topic \
  module.my-fancy-module.google_pubsub_topic.hot-topic
```
]

#centered-slide[
= Infrastrukturen i `amedia-adp-*`
]

#slide[
== `amedia-adp-sources`

Her styres det meste av #link("https://github.com/amedia/terraform-selvbetjening/")[`amedia/terraform-selvbetjening`].

Relevante moduler ligger i `modules/amedia-adp-sources`, mens instansieringen av disse ligger i `projects/amedia-adp-sources`.

#pause

== `amedia-adp-{prod,test}`

Denne infrastrukturen styres med en god blanding av Terraform fra #link("https://github.com/amedia/adp-infrastructure")[`amedia/adp-infrastructure`], ClickOps™, DataFlow og Airflow.

En stund var tilstanden i Terraform og virkeligheten ute av synk, som har medført mye ClickOps™.
Dette skal nå være rettet opp i, og vi har lik struktur som i `terraform-selvbetjening`.

Et mål er å flytte det som ligger i `adp-infrastructure` over i `terraform-selvbetjening`.
]

#slide[
== Ymse

- `amedia-adp-dbt-*`
- `amedia-adp-marts`
- `amedia-analytics-eu`
- `amedia-data-restricted`

Disse har jeg ikke oversikt over.
]

#slide[
  = Annet

  - `terraform fmt -recursive` og `terraform validate`
  #uncover("2-")[- Kan jeg hoppe ressurser om noen andre har skapt mye drift? #uncover("3-")[ \ (Ja, se `terraform apply -target=<resource-address>`).]]
  #uncover("4-")[- Hva er Atlantis?]
  #uncover("5-")[- Alternativer til Terraform?]

]

#slide[
#heading(outlined: false)[Oppsummering]

#v(1em)

#line-by-line[
  - Terraform (og andre _IaC_-verktøy) er en måte å håndtere infrastruktur gjennom å beskrive ønsket tilstand framfor sekvenser av handlinger.
  - Bruk av _IaC_  gjør at tjenestene våre blir mer reproduserbare og bedre dokumentert.
  - Vi har sett på en del vanlige operasjoner og håndtering av "drift".
  - Vi har sett på hvordan vi bruker Terraform i ADP sine prosjekter.
]

#set align(right)
#v(1fr)
#image("assets/Terraform_Logo.svg", height: 20%)
]
