# Helpful Front-end Styleguide

*Note: this guide is growing as we run into problems or discussions while building Helpful. Feel free to make your own changes.*

## Philosophy
Aim to write re-usable, stand-alone modules that can be placed anywhere in the HTML. Helpful is growing fast and your code should be able to adapt to changes.

## Technology
Helpful uses Compass (SASS) in the SCSS syntax.

## Guidelines

### Readability
* Use soft indent of 2 spaces
* Opening bracket goes on the same line as the selector
* One space between selector and opening bracket
* Closing bracket has its own line

```
.example {
  property: value;
}
```

### Modules
* All elements are called modules and go in `modules/`
* If a module is reusable, add it to the styleguide found in `app/views/pages/styleguide.html.erb`


```
  <div class="example-container">
    <div class="example">
      <h4 class="example-title">
      <ul class="example-list">
        <li class="example-list-item">Example</li>
        <li class="example-list-item">Example</li>
      </ul>
    </div>
  </div>
```

### Layouts
* When styling element positioning on a page, consider using a layout
* All layout classes have a `l-` prefix

```
  <div class="l-example-container">
    <div class="l-example-sidebar"></div>
    <div class="l-example-main"></div>
  </div>
```

### Naming
* All lowercase
* Separate words with a hypen `-`
* Namespace all elements with the name of the module
* Don't use id's for styling
* Avoid using HTML elements for styling

### SCSS Specifics
* All `@extend` or `@include` go first

### CSS
* Everything uses `box-sizing: border-box`

