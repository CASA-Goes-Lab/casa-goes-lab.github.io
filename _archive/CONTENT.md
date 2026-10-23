# Original site content reference
Combined reference of Markdown, HTML, YAML, and JSON source, including template text and commented sample content. The original files in original/ are the authoritative copies; styles, scripts, fonts, images, and project files are preserved there too.

## _config.yml

````````text
baseurl: ''
permalink: pretty
title: 'Casa Góes Lab'

logo:
  mobile: "images/logo/casagoesnotext.svg"
  mobile_height: "40px"
  mobile_width: "40px"
  desktop: "images/logo/casagoesnotext.svg"
  desktop_height: "60px"
  desktop_width: "120px"

home: 
  limit_services: 3

collections:
  research:
    output: true
  #   sort_by: weight
  team:
    output: true
    parmalink: /team/:path/
  news:
    output: false

defaults:
  # - scope:
  #     path: ""
  #     type: "services"
  #   values:
  #     layout: "service"
  - scope:
      path: ""
      type: "Team"
    values:
      layout: "team"

sass:
  style: compressed # possible values: nested expanded compact compressed

plugins:
  - jekyll-environment-variables

exclude:
  - Gemfile
  - Gemfile.lock
  - node_modules
  - vendor/bundle/
  - vendor/cache/
  - vendor/gems/
  - vendor/ruby/
  - LICENSE.md
  - LICENSE
  - README.md

````````

## _data/_includes/call.html

````````text
<div class="call">
  <div class="call-box-top">
    {% if site.data.contact.phone %}
        <div class="call-phone"><strong>Phone: </strong> {{ site.data.contact.phone }} </div>
    {% endif %}
    {% if site.data.contact.email %}
    <div class="call-email"><strong>Email: </strong>
      <a href="mailto:{{ .site.data.contact.email }}">
        {{ site.data.contact.email }}
      </a>
    </div>
    {% endif %}
  </div>
    {% if include.show_button %}
      <div class="call-box-bottom">
        <a href="{{ site.data.contact.contact_button_link }}" class="button">Contact</a>
      </div>
    {% endif %}
</div>

````````

## _data/_includes/footer.html

````````text
<div class="footer">
  <div class="container">
    <div class="row">
      <div class="col-12">
        <div class="footer-inner">
          <h2 class="footer-title">{{site.title}}</h2>
          <ul>
            {% assign footermenu = site.data.menus.footer | sort: 'weight'  %}
            {% for item in footermenu %}
            <li class="{% if item.url == page.url %}active{% endif %}">
              <a href="{{ item.url | relative_url }}">{{ item.name }}</a>
            </li>
            {% endfor %}
          </ul>
        </div>
      </div>
    </div>
  </div>
</div>

````````

## _data/_includes/google-analytics.html

````````text
{% if jekyll.environment == "production" %}
    {% assign gid = site.env.NETLIFY_GOOGLE_ANALYTICS_ID %}
    {% if gid %}
    <script async src="https://www.googletagmanager.com/gtag/js?id={{ gid }}"></script>
    <script>
      window.dataLayer = window.dataLayer || [];

      function gtag() {
        dataLayer.push(arguments);
      }
      gtag('js', new Date());
      gtag('config', '{{ $gid }}');
    </script>
    {% elsif site.data.seo.google_analytics_id %}
    <script async src="https://www.googletagmanager.com/gtag/js?id={{ site.data.seo.google_analytics_id }}"></script>
    <script>
      window.dataLayer = window.dataLayer || [];

      function gtag() {
        dataLayer.push(arguments);
      }
      gtag('js', new Date());
      gtag('config', '{{ site.data.seo.google_analytics_id }}');
    </script>
    {% endif %}
{% endif %}
````````

## _data/_includes/hamburger.html

````````text
<button id="toggle-main-menu-mobile" class="hamburger hamburger--slider" type="button" aria-label="Mobile Menu">
  <span class="hamburger-box">
    <span class="hamburger-inner"></span>
  </span>
</button>
````````

## _data/_includes/header.html

````````text
<div class='header'>
  <div class="container">

    <!-- For image logo after complete the casa goes logo -->
    <div class="logo">
      <a href="{{ site.baseurl }}"><img width="{{ site.logo.desktop_width }}" height="{{ site.logo.desktop_height }}" alt="{{ site.title }}" src="{{ site.logo.desktop | relative_url }}" /></a>
    </div>
    <!-- <div class="logo">
      <a href="{{ site.baseurl }}">Casa Góes Lab</a>
    </div> -->
    <div class="logo-mobile">
      <a href="{{ site.baseurl }}"><img width="{{ site.logo.mobile_width }}" height="{{ site.logo.mobile_height }}" alt="{{ site.title }}" src="{{ site.logo.mobile | relative_url }}" /></a>
    </div>
    {% include main-menu.html %}
    {% include hamburger.html %}
  </div>
</div>

````````

## _data/_includes/main-menu-mobile.html

````````text
<div id="main-menu-mobile" class="main-menu-mobile">
  {% assign mainmenu = site.data.menus.main | sort: 'weight'  %}
  <ul>
    {% for item in mainmenu %}
    <li class="{% if item.url == page.url %}active{% endif %}">
      <a href="{{ item.url | relative_url }}">{{ item.name }}</a>
    </li>
    {% endfor %}
  </ul>
</div>

````````

## _data/_includes/main-menu.html

````````text
<div id="main-menu" class="main-menu">
  {% assign mainmenu = site.data.menus.main | sort: 'weight'  %}
  <ul>
    {% for item in mainmenu %}
    <li class="{% if item.url == page.url %}active{% endif %}">
      <a href="{{ item.url | relative_url }}">{{ item.name }}</a>
    </li>
    {% endfor %}
  </ul>
</div>

````````

## _data/_includes/social.html

````````text
<div class="social">
  {% for item in site.data.social %}
    <a href="{{ item.link }}" target="blank"><img src="{{ item.image | relative_url }}" title="{{ item.name }}" alt="{{ item.name }}" /></a>
  {% endfor %}
</div>

````````

## _data/_includes/sub-footer.html

````````text
<div class="sub-footer">
  <div class="container">
    <div class="row">
      <div class="col-12">
        <div class="sub-footer-inner">
          {% if site.data.social %}
            {% include social.html %}
          {% endif %}
          {% if site.data.seo.copyright_text %}
          <div class="copyright">{{ site.data.seo.copyright_text }}</div>
          {% endif %}
        </div>
      </div>
    </div>
  </div>
</div>
````````

## _data/contact.yml

````````text
email: 'jekyllserif@example.com'
phone: '1800 123 000'
contact_button_link: 'contact'

````````

## _data/features.json

````````text
[
  {
    "title": "Security of Critical Systems",
    "description": "",
    // "image": {
    //   "url": "images/features/noun_branding_1885335.svg",
    //   "width": 80,
    //   "height": 80
    // }
  },
  {
    "title": "Robustness of Discrete Systems",
    "description": "",
    // "image": {
    //   "url": "images/features/noun_The Process_1885341.svg",
    //   "width": 80,
    //   "height": 80
    // }
  },
  {
    "title": "Learning from Demonstrations with Uncertainty",
    "description": "",
    // "image": {
    //   "url": "images/features/noun_3d modeling_1885342.svg",
    //   "width": 80,
    //   "height": 80
    // }
  }
]

````````

## _data/menus.yml

````````text
main:
  - name: "Home"
    url: "/"
    weight: 1
    #Overview of research project
  - name: "Research"
    url: "/research/"
    weight: 2
    #Overview of research project
  - name: "Team"
    url: "/team/"
    weight: 3
    # List of current members and alumni
  - name: "Publications"
    url: "/publications/"
    weight: 4
    # List of publications with blog posts about them
  # - name: "Gallery"
  #   url: "/gallery/"
  #   weight: 5
    # Some recent activities photos
  # - name: "Contact"
  #   url: "/contact/"
  #   weight: 6
    # Prospective students


# Remove footer
footer:
  - name: "Home"
    url: "/"
    weight: 1
  - name: "Contact"
    url: "/contact/"
    weight: 2

````````

## _data/seo.yml

````````text
google_analytics_id: ""  
# meta_twitter_site: "@zerostaticio"
# meta_twitter_creator: "@zerostaticio"
copyright_text: 'Created with <a class="zerostatic" href="https://www.zerostatic.io">www.zerostatic.io</a>'

````````

## _data/social.json

````````text
[
  {
    "name": "Github",
    "link": "https://github.com/CASA-Goes-Lab",
    "image": "images/social/github.svg"
  },
  {
      "name": "Email",
      "link": "mailto:romulo@psu.edu ",
      "image": "images/social/email.svg"
  }
]

````````

## _layouts/contact.html

````````text
---
title: Contact
layout: default
bodyClass: "page-contact"
---

<div class="container pb-6 pt-6 pt-md-10 pb-md-10">
    <div class="row justify-content-start">
        <div class="col-12 col-md-8">
            <div class="service service-single">
                <h1 class="title">{{page.title}}</h1>
                {% include call.html show_button=false %}
                <div class="content mt-4">{{content}}</div>
            </div>
        </div>
    </div>
</div>

````````

## _layouts/default.html

````````text
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <title>{% if page.title %}{{page.title}}{% else %}{{ site.title | escape }}{% endif %}</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link rel="icon" type="image/png" href="{{ '/images/favicon-cglab.png' | relative_url }}"> 
  <!-- Google Fonts CDN -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&display=swap" rel="stylesheet">
  <!-- Self host font -->
  <!-- <link rel="preload" href="{{ '/assets/fonts/playfair-display.woff2' | relative_url }}" as="font" type="font/woff2" crossorigin> -->
  <link href="{{ '/assets/css/style.css' | relative_url }}" rel="stylesheet">
  {% if page.description %}<meta name="description" content="{{ page.description }}" />{% endif %}
  {% if page.meta_title %}<meta property="og:title" content="{{ page.meta_title }}"/>{% else %}<meta property="og:title" content="{{ page.title }}"/>{% endif %}
  <meta property="og:type" content="website"/>
  <meta property="og:url" content="{{ url }}"/>
  <!-- {% if page.image %}<meta property="og:image" content="{{ page.image | absolute_url }}"/>{% endif %} -->
  <!-- {% if page.description %}<meta property="og:description" content="{{ page.description }}"/>{% endif %} -->
  <!-- <meta name="twitter:card" content="summary"/>
  {% if site.data.seo.meta_twitter_site %}<meta name="twitter:site" content="{{ site.seo.meta_twitter_site }}"/>{% endif %}
  {% if site.data.seo.meta_twitter_creator %}<meta name="twitter:creator" content="{{ site.seo.meta_twitter_creator }}"/>{% endif %} -->

</head>

<body class='page {{layout.bodyClass}}'>
  {% include main-menu-mobile.html %}
  <div id="wrapper" class="wrapper">
    {% include header.html headerClass='header-extra' %}
    <!-- Info in the index.md file -->
    {{content}}
  </div>
  <!-- {% include footer.html %} -->
  {% include sub-footer.html %}
  <script type="text/javascript" src="{{ '/assets/js/scripts.js' | relative_url }}"></script>
  {% include google-analytics.html %}
</body>
</html>

````````

## _layouts/home.html

````````text
---
layout: default
bodyClass: "page-home"
---


<div
  class="bg-image"
>

<div class="intro">
  <!-- <div class="container-fluid"> -->
    <!-- <div class="row d-flex justify-content-center"> -->
      <!-- <div class="col-12" style = "display: flex; /* Makes the container a flex container */ -->
      <!-- justify-content: center; /* Centers content horizontally along the main axis */ -->
      <!-- align-items: center; height: 1vh; text-align: center; width: 100vh;" > -->
       <div class="row d-flex justify-content-center">
       <!-- <div class = "col-9"> -->
        {{ content }}
        {% if page.show_call_box %}
          {% include call.html show_button=true %}
        {% endif %}
        </div>
      <!-- </div> -->
      <!-- {% if page.intro_image %}
      <div class="col-12 col-md-3 col-lg-3 order-1 order-md-2 position-relative">
        <img alt="{{ page.title }}" class="intro-image{% if page.intro_image_absolute %} intro-image-absolute{% endif %}{% if page.intro_image_hide_on_mobile %} intro-image-hide-mobile{% endif %}" src="{{ page.intro_image | relURL }}" />
      </div>
      {% endif %} -->
    <!-- </div> -->
  <!-- </div> -->
</div>
</div>


<!-- Mission -->
<div class="strip">
  <div class="container pt-2 pb-2 pb-md-2">
    <div class="card">
      <h1 class="service-title" style="text-align: center;margin-bottom: 4px">
      Casa Góes Lab Mission
      </h1>
      <div class="underline_mission"></div>
      <p style="text-align: center; font-size: larger;">
      We develop first principle methods to analyze and design complex systems with strong resilience, security and safety guarantees.    
      </p>
      <p style="text-align: center; font-size: large;">
      To achieve these goals, we leverage control and formal methods techniques for modeling, analysis, and design of complex systems.
      Specifically, our group combines discrete event and hybrid systems, supervisory control, and temporal logics.
      Our applications domains include critical infrastructure control systems (manufacturing, water, and transportation), robotics, software systems, and human behavioral systems.
      </p> 
   </div>
  </div>
</div>
<!-- Recent projects descriptions
<div class="strip strip-grey">
  <div class="container pt-6 pb-2 pb-md-2">
    <h2 class="service-title" style="text-align: center;">Recent Projects</h2>
    <br>
    <div class="row justify-content-start">
      {% assign limit = site.home.limit_services | default: 6 %}
      {% for service in site.services limit: limit %}
      <div class="col-12 col-md-4 mb-1">
        <div class="service service-summary">
          
          <div class="service-content">
            <h2 class="service-title">
              <a href="{{ service.url | relative_url }}">{{ service.title }}</a>
            </h2>
            <p>{{ service.excerpt | markdownify | strip_html | truncate: 100 }}</p>
          </div>
        </div>
      </div>
      {% endfor %}
    </div>
    <div class="row justify-content-center">
      <div class="col-auto">
        <a class="button button-primary" href="{{ "services" | relative_url }}">View All Services</a>
      </div>
    </div>
  </div>
</div> -->

<!-- <hr class="custom-hr"> -->


<!-- Lab news coming from an MD file similar to Teams  -->
<!-- Lab news -->
<div class="strip">
  <div class="container pt-2 pb-2 pb-md-2">

    <!-- <div class="col-12 col-md-6 col-lg-12 mb-2" style= "height: 300px;"> -->
      <div class="card">
      <h1 class="service-title" style="text-align: center;margin-bottom: 4px">
      Lab News
      </h1>
      <div class="underline"></div>
      {% if site.news %}
        {% assign news_items = site.news | sort: "date" | reverse | limit: 6 %}
        <div class="news-list">
        {% for news in news_items %}
        <div class="news-entry{% if news.image %} has-image{% endif %}">
          <div class="news-date">{{ news.date | date: "%b %Y" }}</div>
          <div class="news-triangle">▶</div>
          <div class="news-content">{{ news.content | markdownify | remove: '<p>' | remove: '</p>' }}</div>
          {% if news.image %}
          <div class="news-image"><img src="{{ news.image | relative_url }}" alt="{{ news.title }}" /></div>
          {% endif %}
        </div>
        {% endfor %}
        </div>
      {% endif %}
      </div>
  </div>
</div>

<!-- <br> -->
{% if site.data.features %}
<div class="strip strip-primary-gradient-top-bottom-sec">
  
  <div class="container pt-2 pb-2 pt-md-2 pb-md-2">
    <h2 class="service-title" style="text-align: center; color: white">Recent Projects</h2>
    <div class="row pt-2 justify-content-center">
      {% for feature in site.data.features %}
      <div class="col-12 col-md-6 col-lg-4 mb-2">
        {% if feature.image %}
        <div class="card">
        <div class="feature">
          <div class="feature-image"><img alt="{{ feature.title }} logo" src="{{ feature.image.url | relative_url }}" width="{{ feature.image.width }}" height="{{ feature.image.height }}" /></div>
          <h2 class="feature-title">{{ feature.title }}</h2>
          <div class="feature-content">{{ feature.description }}</div>
        </div>
        </div>
        {% else %}
        <div class="card_feature">
        <div class="feature-no-image">
          <h2 class="feature-title">{{ feature.title }}</h2>
        </div>
        </div>
        {% endif %}
      </div>
      {% endfor %}

    </div>
  </div>
</div>
{% endif %}

````````

## _layouts/page.html

````````text
---
layout: default
bodyClass: "page-basic"
---

<div class="container pb-6 pt-6 pt-md-10 pb-md-10">
    <div class="row justify-content-start">
        <div class="col-12 col-md-8">
            <div class="service service-single">
                <h1 class="title">{{page.title}}</h1>
                <div class="content">{{content}}</div>
            </div>
        </div>
    </div>
</div>
````````

## _layouts/service.html

````````text
---
layout: default
bodyClass: "page-service"
---

<div class="container pb-6 pt-6 pt-md-10 pb-md-10">
  <div class="row justify-content-start">
    <div class="col-12 col-md-8">
      <div class="service service-single">
        <h1 class="title">{{page.title}}</h1>
        <div class="content">{{content}}</div>
      </div>
    </div>
  </div>
</div>
````````

## _layouts/services.html

````````text
---
layout: default
bodyClass: "page-services"
---

<div class="intro">
  <div class="container">
    <div class="row justify-content-start">
      <div class="col-12 col-md-7 col-lg-6 order-2 order-md-1">
        {{ content }}
      </div>
      {% if page.intro_image %}
      <div class="col-12 col-md-5 col-lg-6 order-1 order-md-2 position-relative">
        <img alt={{ page.title }} class="intro-image{% if page.intro_image_absolute %} intro-image-absolute{% endif %}{% if page.intro_image_hide_on_mobile %} intro-image-hide-mobile{% endif %}" src="{{ page.intro_image | relative_url }}" />
      </div>
      {% endif %}
    </div>
  </div>
</div>

<div class="container pt-6 pb-6">
  <div class="row">
    {% for service in site.services %}
    <div class="col-12 col-md-6 mb-3">
      <div class="service service-summary">
        <div class="service-content">
          <h2 class="service-title">
            <a href="{{ service.url | relative_url }}">{{ service.title }}</a>
          </h2>
          <p>{{ service.excerpt | markdownify | strip_html | truncate: 100 }}</p>
        </div>
      </div>
    </div>
    {% endfor %}
  </div>
</div>

````````

## _layouts/team.html

````````text
---
layout: default
bodyClass: "page-team"
---

<div class="container pb-6 pt-6 pt-md-10 pb-md-10">
  <div class="row justify-content-start">
    <div class="col-12 col-md-8">
      <div class="team team-single">
        <h1 class="title">{{page.title}}</h1>
        <div class="content">{{content}}</div>
      </div>
    </div>
  </div>
</div>

````````

## _layouts/teams-backup.html

````````text
---
layout: default
bodyClass: "page-teams"
---

<!-- Backup of original teams.html layout -->

{%- raw -%}
{%- include teams.html -%}
{%- endraw -%}

````````

## _layouts/teams.html

````````text
---
layout: default
bodyClass: "page-teams"
---

<div class="group-image-section" style="width: 100%; overflow: hidden; margin-bottom: 0rem; display: flex; justify-content: center;">
    <img src="/images/team/group/cg-group-f25.JPG" alt="Team Group Photo" style="width: 80%; height: auto; max-height: 400px; display: block; object-fit: cover; border-radius: 8px;" />
</div>

<div class="intro-teams">
    <div class="container">
        {{ content }}
        <!-- Professor section -->
        <div class="row justify-content-center">
            {% assign professor = site.team | where: "professor", true | first %}
            {% if professor %}
                <div class="col-md-12">
                    <h2 class="team-name"> {{ professor.title }}</h2>
                    <hr>
                    <div class="team-image">
                        <img width="160" height="160" alt="{{ professor.title }}" class="img-fluid mb-2" src="{{ professor.image | relative_url }}" />
                    </div>
                    <p style = "align-items: left;">{{ professor.jobtitle }}</p>
                    <p style = "align-items: left;">{{ professor.jobdpt}}</p>
                    <p style = "align-items: left;">{{ professor.email}}</p>
                </div>
            {% endif %}
        </div>
        <!-- Graduate students gallery -->
        <h2 class="team-name mt-4">Graduate Students</h2>
        <hr>
        <div class="row">
            {% assign grad_students = site.team | where: "grad-student", true | where_exp: "item", "item.alumni != true" | sort: "startdate" %}
            {% for team in grad_students %}
                <div class="col-12 col-md-3 col-lg-3 mb-4">
                    <div class="team-image">
                        {% if team.image and team.placeholder!=true %}
                        <img width="160" height="160" alt="{{ team.title }}" class="img-fluid mb-2" src="{{ team.image | relative_url }}" style="min-width:160px;max-width:100%;height:160px;object-fit:cover;" />
                        {% else %}
                        <img width="160" height="160" alt="{{ team.title }}" class="img-fluid mb-2" src="{{ team.placeholder_loc | relative_url }}" style="width:160px;height:160px;object-fit:cover;" />
                        {% endif %}
                    </div>
                    <h3 style="font-size: 1.1em; margin-bottom: 0.2em;">{{ team.title }}</h3>
                    <p style="font-size: 0.95em; margin-bottom: 0.1em;">{{ team.jobtitle }}</p>
                    <p style="font-size: 0.9em; margin-bottom: 0.1em;">{{ team.jobdpt }}</p>
                    {% if team.topic %}<p style="font-size: 0.9em; margin-bottom: 0.1em;">{{ team.topic }}</p>{% endif %}
                </div>
            {% endfor %}
        </div>
        <!-- Undergraduate students gallery -->
        <h2 class="team-name mt-4">Undergraduate Students</h2>
        <hr>
        <div class="row">
            {% assign ug_students = site.team | where: "ug-student", true | where_exp: "item", "item.alumni != true" | sort: "startdate" %}
            {% for team in ug_students %}
                <div class="col-12 col-md-3 col-lg-3 mb-4">
                    <div class="team-image">
                        {% if team.image and team.placeholder!=true %}
                        <img width="160" height="160" alt="{{ team.title }}" class="img-fluid mb-2" src="{{ team.image | relative_url }}" style="min-width:160px;max-width:100%;height:160px;object-fit:cover;" />
                        {% else %}
                        <img width="160" height="160" alt="{{ team.title }}" class="img-fluid mb-2" src="{{ team.placeholder_loc | relative_url }}" style="width:160px;height:160px;object-fit:cover;" />
                        {% endif %}
                    </div>
                    <h3 style="font-size: 1.1em; margin-bottom: 0.2em;">{{ team.title }}</h3>
                    <p style="font-size: 0.95em; margin-bottom: 0.1em;">Major: {{ team.major }}</p>
                </div>
            {% endfor %}
        </div>
    </div>
 <hr>
</div>
<!-- Breaks git push -->
<div class="Alumni">
    <div class="container mt-5 mb-5">
        <div class="row">
            <div class="col-12 text-left">
                <a href="/alumni/" style="font-size: 1.1em;">See our Alumni</a>
            </div>
        </div>
    </div>
</div>

<!-- <div class="container pt-6 pb-6">
    <div class="row">
        {% assign promoted_teams = site.team | where: "promoted", true | sort: "weight" %}
        {% for team in promoted_teams %}
        <div class="col-12 col-md-6 mb-2">
            <div class="team team-summary team-summary-large">
                {% if team.image %}
                <div class="team-image">
                    <img width="90" height="90" alt="{{ team.title }}" class="img-fluid mb-2" src="{{ team.image | relative_url }}" />
                </div>
                {% endif %}
                <div class="team-meta">
                    <h2 class="team-name"><a href="{{ team.url | relative_url }}">{{ team.title }}</a></h2>
                    <p class="team-description">{{ team.jobtitle }}</p>
                    {% if team.linkedinurl %}
                    <a target="_blank" href="{{ team.linkedinurl }}" rel="noreferrer">LinkedIn</a>
                    {% endif %}
                </div>
                <div class="team-content">{{ team.excerpt | truncate: 120 }}</div>
            </div>
        </div>
        {% endfor %}
    </div>
    <div class="row pt-6 pb-6">
        {% assign teams = site.team | where: "promoted", empty | sort: "weight" %}
        {% for team in teams %}
        <div class="col-12 col-md-4 mb-3">
            <div class="team team-summary">
                {% if team.image %}
                <div class="team-image">
                    <img width="60" height="60" alt="{{ team.title }}" class="img-fluid mb-2" src="{{ team.image | relative_url }}" />
                </div>
                {% endif %}
                <div class="team-meta">
                    <h2 class="team-name"><a href="{{ team.url | relative_url }}">{{ team.title }}</a></h2>
                    <p class="team-description">{{ team.jobtitle }}</p>
                </div>
            </div>
        </div>
        {% endfor %}
    </div>
</div> -->

````````

## _news/2025-07-20-cdc-collab.md

````````text
---
date: 2025-07-20
title: "CDC 2025 Collaboration"
---

One paper in collaboration accepted at CDC 2025. Work done by visiting student Samuel Oliveira from UDESC and in collaboration with PSU CAIS lab. Hope to see you in Rio

````````

## _news/2025-08-10-parastou-icds.md

````````text
---
date: 2025-08-10
title: "Parastou ICDS Selection"
---

Congrats Parastou on being selected to the 2025 ICDS Junior Research Program

````````

## _news/2025-08-20-parastou-exam.md

````````text
---
date: 2025-08-20
title: "Parastou Comprehensive Exam"
---

Congrats Parastou on passing her comprehensive exam

````````

## _news/2025-09-15-nsf.md

````````text
---
date: 2025-09-15
title: "NSF Data Center Resilience Project"
link1: "https://www.nsf.gov/awardsearch/simple-search/"
link1_text: "NSF project"
link2: "https://news.engr.psu.edu/2025/meira-goes-romulo-data-cooling-centers.aspx"
link2_text: "PSU news"
image: "/images/news/2025/romulo-wangda-nsf-25.jpg"
---
New [NSF project](https://www.nsf.gov/awardsearch/simple-search/) to Strengthen Data Center Resilience - [PSU news](https://news.engr.psu.edu/2025/meira-goes-romulo-data-cooling-centers.aspx)

````````

## _news/2025-10-10-wodes.md

````````text
---
date: 2025-10-10
title: "WODES 2026 Associate Editor"
link: "https://wodes2026.events.tue.nl/"
link_text: "18th Workshop on Discrete Event Systems (WODES 2026)"
---

Rômulo will serve as an Associate Editor for the [18th Workshop on Discrete Event Systems (WODES 2026)](https://wodes2026.events.tue.nl/). Consider submitting your work to WODES

````````

## _news/2025-10-15-cdc-cyber.md

````````text
---
date: 2025-10-15
title: "CDC 2025 Cybersecurity Paper"
link: "https://arxiv.org/pdf/2510.11405"
link_text: "Arxiv"
---

Our CDC 2025 accepted paper on Cybersecurity Control Recovery is now available on [Arxiv](https://arxiv.org/pdf/2510.11405)

````````

## _news/2025-12-01-samuel-cdc.md

````````text
---
date: 2025-12-01
title: "CDC25 Presentation"
image: "/images/news/2025/samuel-cdc25.jpg"
---

Samuel Oliveira from UDESC presenting our collaborative work at CDC25: [Paper](https://ieeexplore.ieee.org/abstract/document/11312935)

````````

## _news/2026-01-15-parastou-acc.md

````````text
---
date: 2026-01-15
title: "Parastou Paper Acceptance"
---

Congrats to Parastou on her paper acceptance to ACC26!

````````

## _news/2026-03-13-wodes.md

````````text
---
date: 2026-03-13
title: "2026 WODES"
---

Three papers accepted at [2026 Workshop on Discrete Event Systems (WODES)](https://wodes2026.events.tue.nl/), two papers in collaboration with the [CAIS lab](https://www.caislab.com/).
Special congratulations to Shih-Jie on his first paper acceptance!
````````

## _news/2026-05-02-grads.md

````````text
---
date: 2026-05-02
title: "2026 Graduation"
image: "/images/news/2026/end-of-semester-26.jpg"
---

Congrats to all 2026 Casa Góes graduates: Aafiya, Chenghui, Daniel, Gal, Matthew, Muhammad, Souvik, and Tristan.
We had a celebration for the the graduates and the end of the semester.
````````

## _news/2026-05-25-acc-pres.md

````````text
---
date: 2026-05-25
title: "2026 ACC Presentation"
image: "/images/news/2026/pf-acc26.jpeg"
---

Parastou delivering a great presentation of her work at the [2026 American Control Conference](https://acc2026.a2c2.org/). 
````````

## _news/2026-05-25-tase.md

````````text
---
date: 2026-05-25
title: "TASE paper Mostafa"
---

New paper on online fault-tolerant control in collaboration the [CAIS lab](https://www.caislab.com/) is now available on [IEEE TASE](https://ieeexplore.ieee.org/document/11534318).
````````

## _news/2026-06-08-wodes-pres.md

````````text
---
date: 2026-06-09
title: "2026 WODES Presentation"
image: "/images/news/2026/sj-wodes26.JPG"
---

Shih-Jie doing a great job on his [2026 Workshop on Discrete Event Systems (WODES)](https://wodes2026.events.tue.nl/) paper presentation. 
Our two WODES papers are now available on arXiv: [Neurosymbolic Robustness Analysis](https://arxiv.org/pdf/2606.03872) and [Safe LLM-Enabled Tasks for Multi-Agent Manufacturing](https://arxiv.org/pdf/2604.17142)
````````

## _news/2026-06-12-jdeds-prob-det.md

````````text
---
date: 2026-06-01
title: "JDEDS Probabilistic Attack"
---

Fresh paper from our group on enhanced probabilistic attack detectors is now available on [JDEDS](https://link.springer.com/article/10.1007/s10626-026-00445-w).
````````

## _research/assumption.md

````````text
---
title: "Assumption Aware Supervisory Control Theory"
# date: 2019-04-18T12:33:46+10:00
weight: 6
---

````````

## _research/ltl-learning.md

````````text
---
title: "Learning from Demonstrations"
# date: 2019-03-28T15:14:54+10:00
weight: 3
---

Learning from uncertainty demonstrations
````````

## _research/mergers.md

````````text
---
title: "Mergers"
date: 2019-02-28T15:15:34+10:00
weight: 10
---

Lorem markdownum aequalis strigis. Saetigeri iubeas, vultu huic alvum nondum
de obside ut laniavit arbor palmis, cum quin. Rupes vetat videndo, armigerae
crimen habet Priamum nec.

![Accounting Services](/images/austin-distel-nGc5RT2HmF0-unsplash.jpg)

# Objectives

Financial accounting and financial reporting are often used as synonyms.

1. According to International Financial Reporting Standards: the objective of financial reporting is:
2. To provide financial information that is useful to existing and potential investors, lenders and other creditors in making decisions about providing resources to the reporting entity.
3. According to the European Accounting Association:

## Relevance

Relevance is the capacity of the financial information to influence the decision of its users. The ingredients of relevance are the predictive value and confirmatory value. Materiality is a sub-quality of relevance.

> The ingredients of relevance are the predictive value and confirmatory value.

Information is considered material if its omission or misstatement could influence the economic decisions of users taken on the basis of the financial statements.

## Faithful Representation

Faithful representation means that the actual effects of the transactions shall be properly accounted for and reported in the financial statements. The words and numbers must match what really happened in the transaction. The ingredients of faithful representation are completeness, neutrality and free from error.

## Enhancing Qualitative Characteristics

### Verifiability

Verifiability implies consensus between the different knowledgeable and independent users of financial information. Such information must be supported by sufficient evidence to follow the principle of objectivity.

### Comparability

Comparability is the uniform application of accounting methods across entities in the same industry. The principle of consistency is under comparability. Consistency is the uniform application of accounting across points in time within an entity.

### Understandability

Understandability means that accounting reports should be expressed as clearly as possible and should be understood by those to whom the information is relevant.
Timeliness: Timeliness implies that financial information must be presented to the users before a decision is to be made.

---

## Statement of cash flows

The statement of cash flows considers the inputs and outputs in concrete cash within a stated period. The general template of a cash flow statement is as follows: Cash Inflow - Cash Outflow + Opening Balance = Closing Balance

| Cash Inflow | Outflow   | Opening Balance |
| ----------- | --------- | --------------- |
| _Monday_    | `Tuesday` | **Wednesday**   |
| 1           | 2         | 3               |

**Example 1:** in the beginning of September, Ellen started out with $5 in her bank account. During that same month, Ellen borrowed $20 from Tom. At the end of the month, Ellen bought a pair of shoes for $7. Ellen's cash flow statement for the month of September looks like this:

- Cash inflow: $20
- Cash outflow:$7
- Opening balance: $5
- Closing balance: $20 – $7 + $5 = $18

**Example 2:** in the beginning of June, WikiTables, a company that buys and resells tables, sold 2 tables. They'd originally bought the tables for $25 each, and sold them at a price of $50 per table. The first table was paid out in cash however the second one was bought in credit terms. WikiTables' cash flow statement for the month of June looks like this:

> **Important:** the cash flow statement only considers the exchange of actual cash, and ignores what the person in question owes or is owed.

## Statement of financial position (balance sheet)

The balance sheet is the financial statement showing a firm's assets, liabilities and equity (capital) at a set point in time, usually the end of the fiscal year reported on the accompanying income statement.

- **fixed assets**
  - property
  - building
  - equipment (such as factory machinery)
- **intangible assets**
  - copyrights
  - trademarks
  - patents
    - pending
    - international
- goodwill

Owner's equity, sometimes referred to as net assets, is represented differently depending on the type of business ownership. Business ownership can be in the form of a sole proprietorship, partnership, or a corporation. For a corporation, the owner's equity portion usually shows common stock, and retained earnings (earnings kept in the company). Retained earnings come from the retained earnings statement, prepared prior to the balance sheet.

````````

## _research/robustness.md

````````text
---
title: "Robustness of Discrete Systems"
# date: 2019-05-18T12:33:46+10:00
weight: 2
---

Robustness

<!-- ![Accounting Services](/images/austin-distel-nGc5RT2HmF0-unsplash.jpg)

# Objectives

Financial accounting and financial reporting are often used as synonyms.

1. According to International Financial Reporting Standards: the objective of financial reporting is:
2. To provide financial information that is useful to existing and potential investors, lenders and other creditors in making decisions about providing resources to the reporting entity.
3. According to the European Accounting Association:

## Relevance

Relevance is the capacity of the financial information to influence the decision of its users. The ingredients of relevance are the predictive value and confirmatory value. Materiality is a sub-quality of relevance.

> The ingredients of relevance are the predictive value and confirmatory value.

Information is considered material if its omission or misstatement could influence the economic decisions of users taken on the basis of the financial statements.

## Faithful Representation

Faithful representation means that the actual effects of the transactions shall be properly accounted for and reported in the financial statements. The words and numbers must match what really happened in the transaction. The ingredients of faithful representation are completeness, neutrality and free from error.

## Enhancing Qualitative Characteristics

### Verifiability

Verifiability implies consensus between the different knowledgeable and independent users of financial information. Such information must be supported by sufficient evidence to follow the principle of objectivity.

### Comparability

Comparability is the uniform application of accounting methods across entities in the same industry. The principle of consistency is under comparability. Consistency is the uniform application of accounting across points in time within an entity.

### Understandability

Understandability means that accounting reports should be expressed as clearly as possible and should be understood by those to whom the information is relevant.
Timeliness: Timeliness implies that financial information must be presented to the users before a decision is to be made.

---

## Statement of cash flows

The statement of cash flows considers the inputs and outputs in concrete cash within a stated period. The general template of a cash flow statement is as follows: Cash Inflow - Cash Outflow + Opening Balance = Closing Balance

| Cash Inflow | Outflow   | Opening Balance |
| ----------- | --------- | --------------- |
| _Monday_    | `Tuesday` | **Wednesday**   |
| 1           | 2         | 3               |

**Example 1:** in the beginning of September, Ellen started out with $5 in her bank account. During that same month, Ellen borrowed $20 from Tom. At the end of the month, Ellen bought a pair of shoes for $7. Ellen's cash flow statement for the month of September looks like this:

- Cash inflow: $20
- Cash outflow:$7
- Opening balance: $5
- Closing balance: $20 – $7 + $5 = $18

**Example 2:** in the beginning of June, WikiTables, a company that buys and resells tables, sold 2 tables. They'd originally bought the tables for $25 each, and sold them at a price of $50 per table. The first table was paid out in cash however the second one was bought in credit terms. WikiTables' cash flow statement for the month of June looks like this:

> **Important:** the cash flow statement only considers the exchange of actual cash, and ignores what the person in question owes or is owed.

## Statement of financial position (balance sheet)

The balance sheet is the financial statement showing a firm's assets, liabilities and equity (capital) at a set point in time, usually the end of the fiscal year reported on the accompanying income statement.

- **fixed assets**
  - property
  - building
  - equipment (such as factory machinery)
- **intangible assets**
  - copyrights
  - trademarks
  - patents
    - pending
    - international
- goodwill

Owner's equity, sometimes referred to as net assets, is represented differently depending on the type of business ownership. Business ownership can be in the form of a sole proprietorship, partnership, or a corporation. For a corporation, the owner's equity portion usually shows common stock, and retained earnings (earnings kept in the company). Retained earnings come from the retained earnings statement, prepared prior to the balance sheet. -->

````````

## _research/security.md

````````text
---
title: "Security of Critical Systems"
# date: 2018-11-18T12:33:46+10:00
weight: 1
---

Cybersecurity of Critical Systems

<!-- ![Accounting Services](/images/austin-distel-nGc5RT2HmF0-unsplash.jpg)

# Objectives

Financial accounting and financial reporting are often used as synonyms.

1. According to International Financial Reporting Standards: the objective of financial reporting is:
2. To provide financial information that is useful to existing and potential investors, lenders and other creditors in making decisions about providing resources to the reporting entity.
3. According to the European Accounting Association:

## Relevance

Relevance is the capacity of the financial information to influence the decision of its users. The ingredients of relevance are the predictive value and confirmatory value. Materiality is a sub-quality of relevance.

> The ingredients of relevance are the predictive value and confirmatory value.

Information is considered material if its omission or misstatement could influence the economic decisions of users taken on the basis of the financial statements.

## Faithful Representation

Faithful representation means that the actual effects of the transactions shall be properly accounted for and reported in the financial statements. The words and numbers must match what really happened in the transaction. The ingredients of faithful representation are completeness, neutrality and free from error.

## Enhancing Qualitative Characteristics

### Verifiability

Verifiability implies consensus between the different knowledgeable and independent users of financial information. Such information must be supported by sufficient evidence to follow the principle of objectivity.

### Comparability

Comparability is the uniform application of accounting methods across entities in the same industry. The principle of consistency is under comparability. Consistency is the uniform application of accounting across points in time within an entity.

### Understandability

Understandability means that accounting reports should be expressed as clearly as possible and should be understood by those to whom the information is relevant.
Timeliness: Timeliness implies that financial information must be presented to the users before a decision is to be made.

---

## Statement of cash flows

The statement of cash flows considers the inputs and outputs in concrete cash within a stated period. The general template of a cash flow statement is as follows: Cash Inflow - Cash Outflow + Opening Balance = Closing Balance

| Cash Inflow | Outflow   | Opening Balance |
| ----------- | --------- | --------------- |
| _Monday_    | `Tuesday` | **Wednesday**   |
| 1           | 2         | 3               |

**Example 1:** in the beginning of September, Ellen started out with $5 in her bank account. During that same month, Ellen borrowed $20 from Tom. At the end of the month, Ellen bought a pair of shoes for $7. Ellen's cash flow statement for the month of September looks like this:

- Cash inflow: $20
- Cash outflow:$7
- Opening balance: $5
- Closing balance: $20 – $7 + $5 = $18

**Example 2:** in the beginning of June, WikiTables, a company that buys and resells tables, sold 2 tables. They'd originally bought the tables for $25 each, and sold them at a price of $50 per table. The first table was paid out in cash however the second one was bought in credit terms. WikiTables' cash flow statement for the month of June looks like this:

> **Important:** the cash flow statement only considers the exchange of actual cash, and ignores what the person in question owes or is owed.

## Statement of financial position (balance sheet)

The balance sheet is the financial statement showing a firm's assets, liabilities and equity (capital) at a set point in time, usually the end of the fiscal year reported on the accompanying income statement.

- **fixed assets**
  - property
  - building
  - equipment (such as factory machinery)
- **intangible assets**
  - copyrights
  - trademarks
  - patents
    - pending
    - international
- goodwill

Owner's equity, sometimes referred to as net assets, is represented differently depending on the type of business ownership. Business ownership can be in the form of a sole proprietorship, partnership, or a corporation. For a corporation, the owner's equity portion usually shows common stock, and retained earnings (earnings kept in the company). Retained earnings come from the retained earnings statement, prepared prior to the balance sheet. -->

````````

## _research/wealth-management.md

````````text
---
title: "Wealth Management"
date: 2019-06-18T12:33:46+10:00
weight: 8
---

Lorem markdownum **Achaica revolutaque amore**, penitus puppes nec furit,
clipeus fatetur, mira inter accedere. Dedit dum raptoresque Oete dolorem
Cretaeas enim [ipse pectora excusat](#in-poscat) candentibus fertur? Furtiva
Orontes Erysicthona dona, est per Achille viridi draconis cultis mota milia.

![Accounting Services](/images/austin-distel-nGc5RT2HmF0-unsplash.jpg)

# Objectives

Financial accounting and financial reporting are often used as synonyms.

1. According to International Financial Reporting Standards: the objective of financial reporting is:
2. To provide financial information that is useful to existing and potential investors, lenders and other creditors in making decisions about providing resources to the reporting entity.
3. According to the European Accounting Association:

## Relevance

Relevance is the capacity of the financial information to influence the decision of its users. The ingredients of relevance are the predictive value and confirmatory value. Materiality is a sub-quality of relevance.

> The ingredients of relevance are the predictive value and confirmatory value.

Information is considered material if its omission or misstatement could influence the economic decisions of users taken on the basis of the financial statements.

## Faithful Representation

Faithful representation means that the actual effects of the transactions shall be properly accounted for and reported in the financial statements. The words and numbers must match what really happened in the transaction. The ingredients of faithful representation are completeness, neutrality and free from error.

## Enhancing Qualitative Characteristics

### Verifiability

Verifiability implies consensus between the different knowledgeable and independent users of financial information. Such information must be supported by sufficient evidence to follow the principle of objectivity.

### Comparability

Comparability is the uniform application of accounting methods across entities in the same industry. The principle of consistency is under comparability. Consistency is the uniform application of accounting across points in time within an entity.

### Understandability

Understandability means that accounting reports should be expressed as clearly as possible and should be understood by those to whom the information is relevant.
Timeliness: Timeliness implies that financial information must be presented to the users before a decision is to be made.

---

## Statement of cash flows

The statement of cash flows considers the inputs and outputs in concrete cash within a stated period. The general template of a cash flow statement is as follows: Cash Inflow - Cash Outflow + Opening Balance = Closing Balance

| Cash Inflow | Outflow   | Opening Balance |
| ----------- | --------- | --------------- |
| _Monday_    | `Tuesday` | **Wednesday**   |
| 1           | 2         | 3               |

**Example 1:** in the beginning of September, Ellen started out with $5 in her bank account. During that same month, Ellen borrowed $20 from Tom. At the end of the month, Ellen bought a pair of shoes for $7. Ellen's cash flow statement for the month of September looks like this:

- Cash inflow: $20
- Cash outflow:$7
- Opening balance: $5
- Closing balance: $20 – $7 + $5 = $18

**Example 2:** in the beginning of June, WikiTables, a company that buys and resells tables, sold 2 tables. They'd originally bought the tables for $25 each, and sold them at a price of $50 per table. The first table was paid out in cash however the second one was bought in credit terms. WikiTables' cash flow statement for the month of June looks like this:

> **Important:** the cash flow statement only considers the exchange of actual cash, and ignores what the person in question owes or is owed.

## Statement of financial position (balance sheet)

The balance sheet is the financial statement showing a firm's assets, liabilities and equity (capital) at a set point in time, usually the end of the fiscal year reported on the accompanying income statement.

- **fixed assets**
  - property
  - building
  - equipment (such as factory machinery)
- **intangible assets**
  - copyrights
  - trademarks
  - patents
    - pending
    - international
- goodwill

Owner's equity, sometimes referred to as net assets, is represented differently depending on the type of business ownership. Business ownership can be in the form of a sole proprietorship, partnership, or a corporation. For a corporation, the owner's equity portion usually shows common stock, and retained earnings (earnings kept in the company). Retained earnings come from the retained earnings statement, prepared prior to the balance sheet.

````````

## _team/alumni/aafiya-shaikh.md

````````text
---
title: "Aafiya Shaikh"
date: 2026-01-01
image: "images/team/grad/aafiya-shaikh.jpg"
placeholder: true
placeholder_loc: "images/team/placeholder.png"
jobtitle: "M.S. Student"
jobdpt: "School of Electrical Engineering and Computer Science"
email:
linkedinurl: ""
sentence-projectdescription : ""
paragraph-projectdescription : ""
startdate: 10/2025
enddate: 05/2026
grad-student: true
alumni: true
next_position: "Boeing Company"
weight: 2
---


````````

## _team/alumni/austin-collins.md

````````text
---
title: "Austin Collins"
date: 2023-06-01
image: "images/team/undergrad/collin-ross.jpg"
placeholder: true
placeholder_loc: "images/team/placeholder.png"
jobtitle: "Undergraduate Student"
jobdpt: "University of Maryland, Baltimore County"
major: Mechanical Engineering
email: ""
linkedinurl: ""
sentence-projectdescription : ""
paragraph-projectdescription : ""
startdate: 06/2023
enddate: 08/2023
nextpos:
grad-student: false
ug-student: true
alumni: true
next_position: "Ph.D. at University of Michigan"
---


````````

## _team/alumni/carmen-beleho.md

````````text
---
title: "Carmen Beleho"
date: 2024-06-01
image: "images/team/undergrad/collin-ross.jpg"
placeholder: true
placeholder_loc: "images/team/placeholder.png"
jobtitle: "Undergraduate Student"
jobdpt: "University of Maryland, Baltimore County"
major: "Information Systems"
email: ""
linkedinurl: ""
sentence-projectdescription : ""
paragraph-projectdescription : ""
startdate: 06/2024
enddate: 08/2024
nextpos:
grad-student: false
ug-student: true
alumni: true
next_position: ""
---


````````

## _team/alumni/chenghui-zhu.md

````````text
---
title: "Chenghui Zhu"
date: 2025-06-19
image: "images/team/undergrad/chenghui-zhu.jpg"
jobtitle: "Undergraduate Student"
jobdpt: "School of Electrical Engineering and Computer Science"
major: Electrical Engineering
email: ""
linkedinurl: ""
startdate: 09/2024
enddate: 05/2026
grad-student: false
ug-student: true
alumni: true
next_position: ""
---


````````

## _team/alumni/collin-ross.md

````````text
---
title: "Collin Ross"
date: 2024-07-01
image: "images/team/undergrad/collin-ross.jpg"
placeholder: true
placeholder_loc: "images/team/placeholder.png"
jobtitle: "Undergraduate Student"
jobdpt: "School of Electrical Engineering and Computer Science"
major: Electrical Engineering
email: ""
linkedinurl: ""
sentence-projectdescription : ""
paragraph-projectdescription : ""
startdate: 06/2024
enddate: 05/2025
nextpos:
grad-student: false
ug-student: true
alumni: true
next_position: "Lockheed Martin"
---


````````

## _team/alumni/daniel-miller.md

````````text
---
title: "Daniel Miller"
date: 2025-06-19
image: "images/team/undergrad/daniel-miller.jpg"
jobtitle: "Undergraduate Student"
jobdpt: "School of Electrical Engineering and Computer Science"
major: Electrical Engineering
email: ""
linkedinurl: ""
startdate: 04/2025
enddate: 05/2026
grad-student: false
ug-student: true
alumni: true
next_position: "Northrop Grumman"
---


````````

## _team/alumni/gal-alon.md

````````text
---
title: "Gal Alon"
date: 2025-06-19
image: "images/team/undergrad/gal-alon.jpg"
jobtitle: "Undergraduate Student"
jobdpt: "School of Electrical Engineering and Computer Science"
major: Electrical Engineering
email: "galalon218@gmail.com"
linkedinurl: "https://www.linkedin.com/in/gal-alon-873656246/"
sentence-projectdescription : "Streamlined neural-network system for object detection designed to identify features essential for autonomous navigation."
paragraph-projectdescription : "The project focuses on developing a more capable, AI-based perception system for small autonomous vehicles. Using neural network models, the goal is to build an object detection system that can reliably recognize important visual features in the driving environment. This includes improving the vehicle’s awareness by detecting relevant road signs, identifying oncoming vehicles, and recognizing obstacles in its path to support informed navigation. The objective is to explore AI-driven perception methods as an alternative to traditional color-based approaches."
startdate: 04/2025
enddate: 05/2026
grad-student: false
ug-student: true
alumni: true
next_position: "Master's at Cornell University"
---


````````

## _team/alumni/greg-westfall.md

````````text
---
title: "Greg Westfall"
date: 2024-01-01
image: "images/team/undergrad/greg-westfall.jpg"
placeholder: true
placeholder_loc: "images/team/placeholder.png"
jobtitle: "Undergraduate Student"
jobdpt: "School of Electrical Engineering and Computer Science"
major: Electrical Engineering
email: ""
linkedinurl: ""
sentence-projectdescription : ""
paragraph-projectdescription : ""
startdate: 01/2024
enddate: 05/2025
grad-student: false
ug-student: true
alumni: true
next_position: "Westinghouse Electric Company"
---


````````

## _team/alumni/josh-terza.md

````````text
---
title: "Josh Terza"
date: 2025-06-19
image: "images/team/undergrad/josh-terza.jpg"
placeholder: true
placeholder_loc: "images/team/placeholder.png"
jobtitle: "Undergraduate Student"
jobdpt: "School of Electrical Engineering and Computer Science"
major: Electrical Enginerring
email: ""
linkedinurl: ""
sentence-projectdescription : ""
paragraph-projectdescription : ""
startdate: 06/2025
enddate: 12/2025
grad-student: false
ug-student: true
alumni: true
next_position: ""
---


````````

## _team/alumni/matt-ibarra.md

````````text
---
title: "Matthew Ibarra"
date: 2026-01-01
image: "images/team/undergrad/harwin-bernard.jpg"
placeholder: true
placeholder_loc: "images/team/placeholder.png"
jobtitle: "Undergraduate Student"
jobdpt: "Electrical Engineering Department"
major: Electrical Engineering
email: ""
linkedinurl: ""
startdate: 01/2026
enddate: 05/2026
grad-student: false
ug-student: true
alumni: true
next_position: "Boeing Company"
---


````````

## _team/alumni/md-dony.md

````````text
---
title: "Md-Nur-Adam Dony"
date: 2023-09-01
image: "images/team/undergrad/md-dony.jpg"
placeholder: true
placeholder_loc: "images/team/placeholder.png"
jobtitle: "Master Student"
jobdpt: "School of Electrical Engineering and Computer Science"
major: Electrical Engineering
email: ""
linkedinurl: ""
sentence-projectdescription : ""
paragraph-projectdescription : ""
startdate: 09/2023
enddate: 05/2025
grad-student: true
ug-student: false
alumni: true
next_position: ""
---


````````

## _team/alumni/muhammad-saidi.md

````````text
---
title: "Muhammad Saidi"
date: 2025-06-19
image: "images/team/undergrad/muhammad-saidi.jpg"
placeholder: true
placeholder_loc: "images/team/placeholder.png"
jobtitle: "Undergraduate Student"
jobdpt: "School of Electrical Engineering and Computer Science"
major: Electrical Engineering
email: "aisamuddinsaidi03@gmail.com"
linkedinurl: "https://www.linkedin.com/in/aisamuddinsaidi/"
sentence-projectdescription : "Duckiebot integrated with Intel RealSense for camera-based localization and navigation"
paragraph-projectdescription : "This project integrates a Duckiebot with an Intel RealSense camera to give it better localization using April Tags. The RealSense provides depth and camera data so the Duckiebot can understand where it is in the map. The Duckiebot will also communicate its position to another Duckiebot through simple UDP messaging, so both robots know where each other are. A controller will be used to manage this shared localization information and make sure the Duckiebot can navigate correctly and consistently from point A to point B."
startdate: 09/2025
enddate: 05/2026
grad-student: false
ug-student: true
alumni: true
next_position: ""
---


````````

## _team/alumni/ratnesh-yadav.md

````````text
---
title: "Ratnesh Yadav"
date: 2023-09-01
image: "images/team/undergrad/ratnesh-yadav.jpg"
placeholder: true
placeholder_loc: "images/team/placeholder.png"
jobtitle: "Master Student"
jobdpt: "School of Electrical Engineering and Computer Science"
major: Electrical Engineering
email: ""
linkedinurl: ""
sentence-projectdescription : ""
paragraph-projectdescription : ""
startdate: 09/2023
enddate: 05/2025
grad-student: true
ug-student: false
alumni: true
next_position: "Meta (via Beyondsoft)"
---


````````

## _team/alumni/souvik-kar.md

````````text
---
title: "Souvik Kar"
date: 2025-06-19
image: "images/team/undergrad/souvik-kar.jpg"
placeholder: false
jobtitle: "Undergraduate Student"
jobdpt: "School of Electrical Engineering and Computer Science"
major: "Computer Science"
email: "phantomdflight@gmail.com"
linkedinurl: "https://www.linkedin.com/in/souvik-kar-531b231b1/"
sentence-projectdescription : "I am contributing to the Python MDESops project by enhancing its visualization tools, strengthening software testing, and improving overall developer workflows to support more reliable and intuitive discrete-event systems research."
paragraph-projectdescription : "My work focuses on expanding and refining the Python MDESops software package, a tool that supports modeling and analysis of modular discrete-event systems. This includes developing clearer and more interactive visualizations, improving automated testing to increase reliability, and streamlining various components of the codebase to make the library easier for researchers to use and extend. Through these improvements, I aim to strengthen MDESops as a practical platform for experimentation, teaching, and future research in supervisory control and DES theory."
startdate: 09/2024
enddate: 05/2026
grad-student: false
ug-student: true
alumni: true
next_position: "West Shore Home"
---


````````

## _team/alumni/tristan-germa.md

````````text
---
title: "Tristan Germa"
date: 2025-06-19
image: "images/team/undergrad/tristan-germa.jpg"
jobtitle: "Undergraduate Student"
jobdpt: "School of Electrical Engineering and Computer Science"
major: Electrical Engineering
email: "tristangerma@gmail.com"
linkedinurl: "https://www.linkedin.com/in/tristangerma/"
sentence-projectdescription : "Building a dual-camera indoor positioning system that uses synchronized RealSense D435 depth streams, AprilTag detection, and ROS to estimate robot pose in real time."
paragraph-projectdescription : "This project develops a dual-camera indoor positioning system designed to track Duckietown robots with high accuracy. Two Intel RealSense D435 cameras are strategically mounted in the lab to capture synchronized RGB-D data, enabling reliable detection of AprilTags across overlapping fields of view. The system uses ROS for data acquisition, transforms, and message passing, while custom Python/OpenCV pipelines perform tag detection, depth extraction, and pose estimation. Current work focuses on calibration of the camera pair, coordinate frame alignment, and real-time fusion of observations to produce a stable global pose for robots moving through the environment. The goal is to create a robust, scalable infrastructure that supports multi-robot experiments and research in perception, localization, and autonomous navigation."
startdate: 05/2023
enddate: 05/2026
grad-student: false
ug-student: true
alumni: true
next_position: "Siemens"
---


````````

## _team/graduate-students/parastou-fahim.md

````````text
---
title: "Parastou Fahim"
date: 2025-06-19
image: "images/team/grad/parastou-fahim.jpg"
jobtitle: "Ph.D. Student"
jobdpt: "School of Electrical Engineering and Computer Science"
email: ""
startdate: 2023
linkedinurl: "a"
alumni: false
grad-student: true
weight: 1
---


````````

## _team/graduate-students/shih-jie-shih.md

````````text
---
title: "Shih-Jie Shih"
date: 2025-06-19
image: "images/team/grad/shih-jie.jpg"
jobtitle: "Ph.D. Student"
jobdpt: "School of Electrical Engineering and Computer Science"
email: "jackshih51104611@gmail.com"
linkedinurl: "https://www.linkedin.com/in/shih-jie-s-b8ab6097/"
sentence-projectdescription : "Research in Supervisory Control"
paragraph-projectdescription : "Identify topics for exploration, conduct research, formalize into papers"
startdate: 2025
grad-student: true
alumni: false
weight: 2
---


````````

## _team/romulo.md

````````text
---
title: "Rômulo Meira-Góes"
date: 2025-06-19
image: "images/team/rmg-2021.jpg"
jobtitle: "Assistant Professor"
jobdpt: "School of Electrical Engineering and Computer Science"
email: "romulo at psu.edu"
linkedinurl: "a"
promoted: true
weight: 1
professor: true
---


````````

## _team/undergrad-students/harwin-bernard.md

````````text
---
title: "Harwin Bernard"
date: 2026-01-01
image: "images/team/undergrad/harwin-bernard.jpg"
placeholder: true
placeholder_loc: "images/team/placeholder.png"
jobtitle: "Undergraduate Student"
jobdpt: "Aerospace Engineering Department"
major: Aerospace Engineering
email: ""
linkedinurl: ""
startdate: 2026
grad-student: false
ug-student: true
alumni: false
---


````````

## _team/undergrad-students/kofi-amoa.md

````````text
---
title: "Kofi Amoa"
date: 2025-06-19
image: "images/team/undergrad/kofi-amoa.jpg"
jobtitle: "Undergraduate Student"
jobdpt: "School of Electrical Engineering and Computer Science"
major: Electrical Engineering
email: "kma6375@psu.edu"
linkedinurl: "https://www.linkedin.com/in/kofi-a-psu/"
sentence-projectdescription : "Implementation of a stop controller and eventually intersection control for CASA Duckie town Simulator."
paragraph-projectdescription : "The process is two fold, the Duckie Town Project requires robots to navigate an intersection and as of yet this is not fully realized. The Duckie is to stop at the intersection using a three controller system. One controller is dedicated to lane following which is already refined. The secondary stop controller detects a red line or obstacle and stops just short of the object or intersection. The third controller is tasked with managing the precedence of the stop and lane following controller. In the event that an intersection is reached the master controller stops the lane following controller and enables the stop controller for a period of time before allowing the robot to move forward again. In the event of an obstacle in the Duckie robots path the stop controller has command until the front sensor can no longer detect the robot with the forward-looking LIDAR sensor. This work is only a small component of the Duckie Town Project and after it comes to fruition intersection control will be developed, allowing the Lab to fully realize all capabilities of Duckie Town Simulator."
startdate: 2025
grad-student: false
ug-student: true
alumni: false
---

````````

## _team/undergrad-students/liam-rodgers.md

````````text
---
title: "Liam Rodgers"
date: 2026-01-01
image: "images/team/undergrad/liam-rodgers.jpg"
placeholder: true
placeholder_loc: "images/team/placeholder.png"
jobtitle: "Undergraduate Student"
jobdpt: "School of Electrical Engineering and Computer Science"
major: Electrical Engineering
email: "liro@psu.edu"
linkedinurl: "https://www.linkedin.com/in/kickass"
startdate: 2026
grad-student: false
ug-student: true
alumni: false
---


````````

## _team/undergrad-students/nick-baeta.md

````````text
---
title: "Nicolas Baeta"
date: 2026-01-01
image: "images/team/undergrad/nick-baeta.jpg"
placeholder: true
placeholder_loc: "images/team/placeholder.png"
jobtitle: "Undergraduate Student"
jobdpt: "School of Electrical Engineering and Computer Science"
major: Electrical Engineering
email: ""
linkedinurl: ""
startdate: 2026
grad-student: false
ug-student: true
alumni: false
---


````````

## _team/undergrad-students/vlad-roiban.md

````````text
---
title: "Vlad Roiban"
date: 2025-06-19
image: "images/team/undergrad/vlad-roiban.jpg"
jobtitle: "Undergraduate Student"
jobdpt: "School of Electrical Engineering and Computer Science"
major: Electrical Engineering
email: ""
linkedinurl: ""
startdate: 2024
grad-student: false
ug-student: true
alumni: false
---


````````

## .github/workflows/jekyll.yml

````````text
# This workflow uses actions that are not certified by GitHub.
# They are provided by a third-party and are governed by
# separate terms of service, privacy policy, and support
# documentation.

# Sample workflow for building and deploying a Jekyll site to GitHub Pages
name: Deploy Jekyll site to Pages

on:
  # Runs on pushes targeting the default branch
  push:
    branches: ["master"]

  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

# Sets permissions of the GITHUB_TOKEN to allow deployment to GitHub Pages
permissions:
  contents: read
  pages: write
  id-token: write

# Allow only one concurrent deployment, skipping runs queued between the run in-progress and latest queued.
# However, do NOT cancel in-progress runs as we want to allow these production deployments to complete.
concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  # Build job
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      - name: Setup Ruby
        # https://github.com/ruby/setup-ruby/releases/tag/v1.207.0
        uses: ruby/setup-ruby@4a9ddd6f338a97768b8006bf671dfbad383215f4
        with:
          ruby-version: '3.1' # Not needed with a .ruby-version file
          bundler-cache: true # runs 'bundle install' and caches installed gems automatically
          cache-version: 1 # Increment this number if you need to re-download cached gems
      - name: Setup Pages
        id: pages
        uses: actions/configure-pages@v5
      - name: Build with Jekyll
        # Outputs to the './_site' directory by default
        run: bundle exec jekyll build --baseurl "${{ steps.pages.outputs.base_path }}"
        env:
          JEKYLL_ENV: production
      - name: Upload artifact
        # Automatically uploads an artifact from the './_site' directory by default
        uses: actions/upload-pages-artifact@v3

  # Deployment job
  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4

````````

## about.md

````````text
---
title: About
layout: default
description: About
---
````````

## alumni.md

````````text
---
layout: default
title: Alumni
permalink: /alumni/
---

<div class="container pt-4 pb-4">
  <h1 class="service-title" style="text-align: center;margin-bottom: 4px">Alumni</h1>
  <hr>
  <ul style="list-style: none; padding-left: 0;">
    {% assign alumni = site.team | where: "alumni", true | sort: "date" | reverse %}
    {% for member in alumni %}
      <li style="margin-bottom: 1em;">
        <strong>{{ member.title }}</strong> <br>
        {{ member.jobtitle }} -- {{ member.startdate }} - {{ member.enddate }}<br>
        {% if member.next_position %}Next: {{ member.next_position }}{% endif %}
      </li>
    {% endfor %}
  </ul>
</div>

````````

## builtatlightspeed.json

````````text
{
    "originRepo": "https://github.com/zerostaticthemes/jekyll-serif-theme",
    "title": "Jekyll Serif",
    "description": "Serif is a multi page business theme for Jekyll.",
    "demoUrl": "https://jekyll-advance.netlify.app",
    "categories": {
      "ssg": ["jekyll"],
      "css": ["bootstrap", "scss"],
      "archetype": ["business"],
      "features": ["netlify", "github-pages"],
      "blueprint": ["theme"]
    }
}
````````

## contact.md

````````text
---
title: Contact
layout: default
description: Contact
---
````````

## index.md

````````text
---
title: Casa Góes Lab
layout: home
description: 
intro_image: "images/illustrations/pointing.svg"
intro_image_absolute: false
intro_image_hide_on_mobile: false
show_call_box: false
---
<!-- Content for home page -->
# Casa Góes Lab 
# Controlling Autonomous Systems 
# with Assurances

<!-- Serif contains content types for a typical business website. The theme is fully responsive, blazing fast and artfully illustrated. -->


````````

## publications.md

````````text
---
title: Publications
layout: default
description: Publications
---

Under construction
````````

## README.md

````````text
# Jekyll Serif Theme

Serif is a modern business theme for Jekyll. It contains multiple content types for a typical brochure/marketing website. The theme is fully responsive, blazing fast and artfully illustrated.

[Live Demo](https://jekyll-serif.netlify.app/) |
[Zerostatic Themes](https://www.zerostatic.io)

<a href="https://www.buymeacoffee.com/zerostatic" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>

![Jekyll Serif Theme screenshot](https://www.zerostatic.io/theme/jekyll-serif/jekyll-serif-screenshot.png)

### Theme features

- Jekyll 4.2+
- Netlify & Github Pages ready
- Services (Collection)
- Team (Collection)
- Features (Data)
- SCSS
- 100% Responsive design, animated hamburger and mobile slide in menu
- Bootstrap 4.6 - _Only the bootstrap grid and utilites are imported by default. If you want to use more of the Boostrap library you can uncomment the `@import` in `style.scss`_
- 100/100 Google Lighthouse speed score
- 100/100 Google Lighthouse seo score
- 100/100 Google Lighthouse accessibility score
- 100/100 Google Lighthouse best practices score
- Under 50KB without images or 80KB with images and illustrations ⚡
- Under 20KB without Google fonts ⚡⚡⚡
- Robust example content included
- Royalty free illustrations included

## Installation

### Installing Ruby & Jekyll

If this is your first time using Jekyll, please follow the [Jekyll docs](https://jekyllrb.com/docs/installation/) and make sure your local environment (including Ruby) is setup correctly.

### Installing Theme

Download or clone the theme.

To run the theme locally, navigate to the theme directory and run:

```
bundle install
```

To start the Jekyll local development server.

```
bundle exec jekyll serve
```

To build the theme.

```
bundle exec jekyll build
```

## Deployment

### Netlify

Use Netlify to deploy this theme. This theme contains a valid and tested `netlify.toml` - Feel free to use the 1-click deploy below.

[![Deploy to Netlify](https://www.netlify.com/img/deploy/button.svg)](https://app.netlify.com/start/deploy?repository=https://github.com/zerostaticthemes/jekyll-serif-theme)

### Github Pages

This theme has been tested to work with Github Pages (and Github Project Pages). When using Github Pages you will need to update the `baseurl` in the `_config.yml` otherwise all the css, images and paths will be broken.

For example the site https://zerostaticthemes.github.io/jekyll-serif-theme would have `baseurl: "/jekyll-serif-theme/"`

## Extras

### License

- You cannot create ports of this theme
- You cannot re-sell this theme

### Credits

- Beautiful royalty free Illustrations by Icons8 - https://icons8.com/illustrations/style--pixeltrue
- Stock images by Unsplash - https://unsplash.com/
- Feature icons by Noun Project - https://thenounproject.com/

## Support My Work

I've been building open source themes for all the main static site generators for over 4 years now. My premium themes allow me to continue to allocate time to maintain, improve and build new open source themes.

1. Leave a star ⭐🙏🏻
2. Make a contribution to this theme, add a feature, fix a bug, nothing is to small 
2. Mention this theme on twitter [@zerostaticio](https://twitter.com/zerostaticio) 📢
3. Purchase a premium theme 🔥

### All Jekyll Themes by Zerostatic

- [Jekyll Serif (Open Source)](https://www.zerostatic.io/theme/jekyll-serif/)
- [Jekyll Atlantic (Open Source)](https://www.zerostatic.io/theme/jekyll-atlantic/)
- [Jekyll Advance (Premium)](https://www.zerostatic.io/theme/jekyll-advance/)
- [Jekyll Origin (Premium)](https://www.zerostatic.io/theme/jekyll-origin/)
- [Jekyll Curate (Premium)](https://www.zerostatic.io/theme/jekyll-curate/)

🇦🇺 **Made in Australia** by Robert Austin

````````

## research.md

````````text
---
title: Research
layout: default
description: Research
---

Under construction
````````

## team.md

````````text
---
title: Team
layout: teams
description: Team
permalink: "/team/"
intro_image_absolute: true
intro_image_hide_on_mobile: false
---

# Members

````````