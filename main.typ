// Get Polylux from the official package repository
#import "@preview/polylux:0.3.1": *
#import "@preview/cetz:0.2.2"
#import themes.simple: title-slide, centered-slide, focus-slide, slide, simple-theme

// Make the paper dimensions fit for a presentation and the text larger
#set page(paper: "presentation-16-9")
#set text(size: 20pt, lang: "nb")
#show link: t => [#set text(blue); #underline[#t]]

// Use #polylux-slide to create a slide and style it using your favourite Typst functions
#title-slide[
  = Terraform

  #v(1em)

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
    == Agenda

    - Hvordan lager vi ressurser i skyen?
    - Hva er Terraform?
    - Hvorfor er det lurt å bruke det?
    - Hvordan fungerer det egentlig?
    - Vanlige operasjoner
    - Spesialoperasjoner
  ], align(horizon, image("assets/Terraform_Logo.svg", width: 100%)))
  #v(1fr)
]

#centered-slide[
  = Hvordan lager vi ressurser i skyen?
]

#centered-slide[
  == ClickOps™

  _Den raskeste veien til mål_

  #link("assets/clickops.webm")[video]
]

#slide[
== CLI

_Presist_

```bash
  gcloud --project='amedia-adp-test' pubsub \
    topics create 'my-topic' \
    --message-retention-duration=1d

  gcloud --project='amedia-adp-test' pubsub \
    subscriptions create 'my-subscription' \
    --topic='my-topic'
  ```

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

  _ClickOps og gcloud_

  - Sekvens av steg som forhåpentligvis tar deg til mål
  - Beskriver handlinger, ikke tilstand
  - Er ikke "idempotent"

  #only(1)[#steps_1]
  #only(2)[#steps_2]
]

#centered-slide[
  = Hva er Terraform?

  infrastruktur som kode \
  _(infrastrucure as code, IaC)_
]

#slide[
== Ønsket tilstand

#v(1fr)

#grid(columns: (1fr, 1fr), [
  Jeg vil ha:

  - Et pubsub topic som heter `my-fancy-topic`
  - En subscription som heter `my-fancy-topic-subscription`
    - ack-deadline på 20 sekunder
    - pusher til et endepunkt
], [
#uncover(2)[
#set text(size: 12pt)
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
}
```
]

#v(3em)

])

]

#slide[
  #image("assets/terraform-concepts-1.svg", width: 100%)
]

#centered-slide[
  = Hvorfor bruke Terraform?
]

#slide[
  == Hvorfor bruke Terraform?

  - koden _er_ infrastrukturen $==>$ "dokumentasjonen" vedlikeholdes automatisk
  - historikk ved hjelp av git
  - tjenestene blir mer reproduserbare

  #v(1fr)

  #uncover(2)[
    En tjeneste består av både kode _og_ infrastruktur
  ]
]

#centered-slide[
  = Hvordan fungerer Terraform?
]

#slide[
== Eksempel

#v(1fr)

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
  == I grove trekk

  #grid(columns: (1fr, 1fr), gutter: 1em, [
    - utvikleren endrer på en *konfigurasjon* (f.eks. legger til ressurser i `main.tf`)
    #uncover("2-")[
    - terraform sammenlikner konfigurasjonen med en *tilstand* og lager en *plan*
    ]
    #uncover("3-")[
    - terraform får tilgang til skyen ved hjelp av en *provider*
    ]
    #uncover("4-")[
    - ved hjelp av providerens API-er gjør terraform endringer i ressurser
    ]
    #uncover("5-")[
    - tilstanden er nå oppdatert slik at den stemmer med konfigurasjonen
    ]
  ], [
    / konfigurasjon: filer som slutter med `.tf`
    #uncover("2-")[
    / tilstand: vanligvis `default.tfstate` -- lagret lokalt eller i en bøtte (en *backend*) -- beskriver hvilke ressurser terraform tracker og tilstanden til disse ressursene -- holdes i synk ved hver `terraform plan/refresh`
    / plan: en sekvens av handlinger som utgjør en diff, og fører til at tilstanden er slik konfigurasjonen tilsier
    ]
    #uncover("3-")[
    / provider: en plugin som beskriver hvilke ressurser som er tilgjengelige, og hvordan de konfigureres
    ]
  ])
]


