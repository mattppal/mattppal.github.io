---
layout: page
title: books
permalink: /books/
---
In my free time, I really enjoy reading about passionate teams, successful companies, and interesting people. Here's what I've been into lately ordered by date of completion:

## Reading

<div class="list-group">
{% for book in site.data['reading'] %}
    <a href= "{{ book.link }}" class="list-group-item list-group-item-action flex-column align-items-start">
      <div class="d-flex w-100 justify-content-between">
        <h5 class="mb-1">{{ book.title }}</h5>
          <p class="mb-1">{{ book.author }}</p>
        <!-- <small>{{ book.date_read }}</small> -->
      </div>
    </a>
{% endfor %}
</div>

## Read

<div class="list-group">
{% for book in site.data['read'] %}
    <a href= "{{ book.link }}" class="list-group-item list-group-item-action flex-column align-items-start">
      <div class="d-flex w-100 justify-content-between">
        <h5 class="mb-1">{{ book.title }}</h5>
          <p class="mb-1">{{ book.author }}</p>
        <!-- <small>{{ book.date_read }}</small> -->
      </div>
    </a>
{% endfor %}
</div>