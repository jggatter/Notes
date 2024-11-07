# CSS Pagination
#css #pagination #buttons

## Simple pagination

We can use an anchor group of numbers and arrows to allow
users to navigate through pages of different items.

```css
.pagination {
  display: inline-block;
}

.pagination a {
  color: black;
  float: left; /* link group */
  padding: 8px 16px;
  text-decoration: none; /* remove underline */
  transition: background-color .3s;
}

/* current page link */
.pagination a.active {
  background-color: #4CAF50;
  color: white;
}

/* hover effect over other links */
.pagination a:hover:not(.active) {
  background-color: #dddddd;
}
```
```html
<div class="pagination">
  <a href="#">&laquo;</a> <!-- l arrow -->
  <a href="#">1</a>
  <a href="#" class="active">2</a>
  <a href="#">3</a>
  <a href="#">4</a>
  <a href="#">5</a>
  <a href="#">6</a>
  <a href="#">&raquo;</a> <!-- r arrow -->
</div>
```

## Breadcrumbs

A variation of pagination "breadcrumbs" shows the path of links
a user took. E.g. Home / Pictures / Summer '15 / Italy

We can do this a horizontal list:
```css
ul.breadcrumb {
  padding: 8px 16px;
  list-style: none;
  background-color: #eeeeee;
}

ul.breadcrumb li {
  display: inline;
}

ul.breadcrumb li+li:before {
  padding 8px;
  color: black;
  content: "/\00a0";
}
```
