# CSS Intro and Syntax
#css #syntax #selectors #declarations

## Introduction

Cascading Style Sheets (CSS) describes how HTML elements are to be displayed
on screen, paper, or in other media.

It can control the layout of multiple web pages all at once.

External stylesheets are stored in CSS files (.css).

## History

HTML was created to describe the content of a web page.
It was never intended to contain tags for formatting a web page.
Tags like `<font>` were introduced in HTML 3.2 spec, causing nightmares.
The World Wide Web Consortium (W3C) created CSS to resolve the problem.
CSS removed style formatting from HTML pages.

## Syntax

### Declarations

Note this example:
```css
h1 {color:blue; font-size:12px;}
```

Now let's break it down:
```css
   h1                       {color     :blue   ; font-size :12px   ;}
/* <Selector> <Declarations>{<Property>:<Value>; <Property>:<Value>;} */
```

The selector points to the HTML element we want to style.
For more detail on selectors see [[02 Selectors]]

The declaration block `{}` contains declaration(s) delimited by semi-colon.
Each declaration contains a CSS property and a value separated by colon.
### Comments

Comments are used to explain code. They're ignored by the browser.
A comment starts and ends with an opening `/*` and a closing `*/`.
Comments can literally be added anywhere within the style sheet.
Comments can span multiple lines.

HTML comments start and end with `<!--` and `-->`.