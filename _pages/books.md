---
layout: page
title: books
permalink: /books/
---

In my free time, I enjoy reading about passionate teams, successful companies, and interesting people. Lately, I've also began exploring ideas about spirituality, consciousness, and self-compassion. Here's what I've been into lately ordered by date of completion:

## Reading

<div>
{% for book in site.data['reading'] %}
    <a href= "{{ book.link }}">
      <div>
        <h5>{{ book.title }}</h5>
          <p>{{ book.author }}</p>
        <!-- <small>{{ book.date_read }}</small> -->
      </div>
    </a>
{% endfor %}
</div>

## Read

<div>
{% for book in site.data['read'] %}
    <a href= "{{ book.link }}">
      <div>
        <h5>{{ book.title }}</h5>
          <p>{{ book.author }}</p>
        <!-- <small>{{ book.date_read }}</small> -->
      </div>
    </a>
{% endfor %}
</div>
