# Handling Events
Handling events with React elements is very similar to handling events on DOM elements. There are some syntax differences:

React events are named using camelCase, rather than lowercase.
With JSX you pass a function as the event handler, rather than a string.
For example, the HTML:
```js
<button onclick="activateLasers()">
  Activate Lasers
</button>
```
is slightly different in React:

```html
<button onClick={activateLasers}>
  Activate Lasers
</button>
```

Another difference is that you cannot return `false` to prevent default behavior in React. You must call `preventDefault` explicitly. For example, with plain HTML, to prevent the default form behavior of submitting, you can write:
```html
<form onsubmit="console.log('You clicked submit.'); return false">
  <button type="submit">Submit</button>
</form>
```
In React, this could instead be:
```js
function Form() {
  function handleSubmit(e) {
    e.preventDefault(); // Here, e is a synthetic event. 
    console.log('You clicked submit.');
  }

  return (
    <form onSubmit={handleSubmit}>
      <button type="submit">Submit</button>
    </form>
  );
}
```
Here, `e` is a _synthetic event_. React defines these synthetic events according to the W3C spec, so you don’t need to worry about cross-browser compatibility. React events do not work exactly the same as _native events_. See the `SyntheticEvent` reference guide to learn more.

When you define a component using an ES6 class, a common pattern is for an event handler to be a method on the class. For example, this _Toggle_ component renders a button that lets the user toggle between “ON” and “OFF” states:
```js
class Toggle extends React.Component {
  constructor(props) {
    super(props);
    this.state = {isToggleOn: true};

    // This binding is necessary to make `this` work in the callback
    this.handleClick = this.handleClick.bind(this);
  }

  handleClick() {
    this.setState(prevState => ({
      isToggleOn: !prevState.isToggleOn
    }));
  }

  render() {
    return (
      <button onClick={this.handleClick}>
        {this.state.isToggleOn ? 'ON' : 'OFF'}
      </button>
    );
  }
}

ReactDOM.render(
  <Toggle />,
  document.getElementById('root')
);
```
The `bind()` method creates a new function that, when called, has its this keyword set to the provided value, with a given sequence of arguments preceding any provided when the new function is called.

You have to be careful about the meaning of `this` in JSX callbacks. In JavaScript, class methods are _not bound_ (`bind()`) by default. If you forget to `bind` `this.handleClick` and pass it to `onClick`, this will be undefined when the function is actually called.

This is not React-specific behavior; it is a part of how functions work in JavaScript. _Generally, if you refer to a method without `()` after it, such as `onClick={this.handleClick}`, you should bind that method._

If calling `bind` annoys you, there are two ways you can get around this. If you are using the experimental public class fields syntax, you can use class fields to correctly bind callbacks:
```js
class LoggingButton extends React.Component {
  // This syntax ensures `this` is bound within handleClick.
  // Warning: this is *experimental* syntax.
  handleClick = () => {
    console.log('this is:', this);
  }

  render() {
    return (
      <button onClick={this.handleClick}>
        Click me
      </button>
    );
  }
}
```
This syntax is enabled by default in Create React App.

If you aren’t using class fields syntax, you can use an arrow function in the callback:
```js
class LoggingButton extends React.Component {
  handleClick() {
    console.log('this is:', this);
  }

  render() {
    // This syntax ensures `this` is bound within handleClick
    return (
      <button onClick={() => this.handleClick()}>
        Click me
      </button>
    );
  }
}
```
The problem with this syntax is that a _different callback is created each time the `LoggingButton` renders_. In most cases, this is fine. _However, if this callback is passed as a prop to lower components, those components might do an extra re-rendering_. We __generally recommend binding in the constructor or using the class fields syntax, to avoid this sort of performance problem.__

## Passing Arguments to Event Handlers
Inside a loop, it is common to want to pass an extra parameter to an event handler. For example, if `id` is the row ID, either of the following would work:
```js
<button onClick={(e) => this.deleteRow(id, e)}>Delete Row</button>
<button onClick={this.deleteRow.bind(this, id)}>Delete Row</button>
```
The above two lines are equivalent, and use _arrow functions_ and _`Function.prototype.bind`_ respectively.

In both cases, the `e` argument representing the React event will be passed as a **second argument after the ID**. With an arrow function, we have to pass it explicitly, but with bind any further arguments are automatically forwarded.

