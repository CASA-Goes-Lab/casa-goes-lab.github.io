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
