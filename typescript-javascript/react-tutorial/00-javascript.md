# Reintroduction to Javascript
Based on [this article](https://developer.mozilla.org/en-US/docs/Web/JavaScript/A_re-introduction_to_JavaScript).  

JavaScript is a loosely __typed__ and __dynamic__ language. Variables in JavaScript are not directly associated with any particular value type, and any variable can be assigned (and re-assigned) values of all types:

## Types

* `Number`: a double-precision 64-bit binary format IEEE 754 value (numbers between `-(2^53 − 1)` and `2^53 − 1`). In addition to representing __floating-point numbers__, the `Number` type has three symbolic values: `+Infinity`, `-Infinity`, and `NaN` ("Not a Number"). An _apparent_ integer is in fact implicitly a float.
* `BigInt`: numeric primitive in JavaScript that can represent __integers__ with arbitrary precision. With `BigInt`s, you can safely store and operate on __large integers__ even beyond the safe integer limit for Numbers. A BigInt is created by appending `n` to the end of an integer or by calling the constructor.
* `String`: Used to represent textual data. It is a set of "elements" of 16-bit unsigned integer values. Each element in the `String` occupies a position in the `String`. The first element is at index `0`, the next at index `1`, and so on. The length of a String is the number of elements in it. Unlike some programming languages (such as C), JavaScript strings are __immutable__. This means that once a string is created, it is not possible to modify it. _However_, it is still possible to create another string based on an operation on the original string.
* `Boolean`: logical entity representing `true` or `false`.
* `Function`:
* `Object`: In computer science, an object is a value in memory which is possibly referenced by an identifier. In JavaScript, objects can be seen as a __collection of properties__. With the object literal syntax, a limited set of properties are initialized; then __properties can be added and removed__. Property values can be __values of any type__, including other objects, which enables building complex data structures. Properties are _identified using key values_. A __key value is either a `String` or a `Symbol` value__.
* `Symbol` (new in ES2015): a __unique__ and __immutable__ primitive value and may be used as the key of an `Object` property (see below). In some programming languages, `Symbol`s are called "atoms". [More details](https://developer.mozilla.org/en-US/docs/Glossary/Symbol).
* `undefined`: undefined is a primitive value automatically assigned to variables that have just been declared, or to formal arguments for which there are no actual arguments.
* `null`: In computer science, a null value represents a reference that points, generally intentionally, to a __nonexistent or invalid object or address__. The meaning of a null reference varies among language implementations. In JavaScript, it is marked as one of the __primitive values, because its behavior is seemingly primitive__. But in certain cases, null is not as "primitive" as it first seems! __Every Object is derived from null value, and therefore typeof operator returns object for it:__
```javascript
typeof null === 'object' // true
```

### `typeof` operator

Can be used on the primitive _Data Types_: `Number`, `BigInt`, `String`, `Symbol`, `Boolean`, `undefined`. Example:
`typeof someinstance === "undefined"`
Note: will return a lowercase string representing the name, e.g. `"bigint"` for `BigInt`.

Can also be used on _Structural Types_ `Object` and `Function`:
* For `Object`, can be used on any that is instantianted with `new` keyword.
* `instanceof` can tell which type of object.

Another type is the _Structural Root_ primitive:
`null` : `typeof instance === "object"`. Special primitive type having additional usage for its value: if object is not inherited, then `null` is shown;

## Variables

New variables in JavaScript are declared using one of three keywords: `let`, `const`, or `var`.
* `let` allows you to declare block-level variables. The declared variable is available from the block it is enclosed in.
* `const` allows you to declare variables whose values are never intended to change. The variable is available from the block it is declared in.
* `var` is the most common declarative keyword. It does not have the restrictions that the other two keywords have. This is because it was traditionally the only way to declare a variable in JavaScript. A variable declared with the `var` keyword is available from the function it is declared in.

## Operators

You can use `++` and `--` to increment and decrement respectively. These can be used as a prefix or postfix operators.

The `+` operator also does string concatenation.
If you add a string to a number (or other value) everything is converted into a string first. This might trip you up.

The `==` operator performs type coercion if you give it different types.
```javascript
123 == '123'; // true
1 == true; // true
```
To avoid type coercion, use the `===` operator:
```javascript
123 === '123'; // false
1 === true;    // false
```
There are also != and !== operators.

[Bitwise operators](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators)

## Control structures (`if`, etc.)

### `if`, `else if`, `else`

```javascript
var name = 'kittens';
if (name === 'puppies') {
  name += ' woof';
} else if (name === 'kittens') {
  name += ' meow';
} else {
  name += '!';
}
name === 'kittens meow';
```

### `while`, `do while`

JavaScript has `while` loops and `do while` loops. The first is good for basic looping; the second for loops where you wish to ensure that the body of the loop is executed at least once:
```javascript
while (true) {
  // an infinite loop!
}

var input;
do {
  input = get_input();
} while (inputIsNotValid(input));
```

### `for`

JavaScript's `for` loop is the same as that in C and Java: it lets you provide the control information for your loop on a single line.
```javascript
for (var i = 0; i < 5; i++) {
  // Will execute 5 times
}
```

JavaScript also contains two other prominent for loops: `for`...`of`
```javascript
for (let value of array) {
  // do something with value
}
```

and `for`...`in`:
```javascript
for (let property in object) {
  // do something with value
}
```
For arrays this iterates over the indices instead of the actual values.

### Operators

The `&&` and `||` operators use short-circuit logic, which means whether they will execute their second operand is dependent on the first. This is useful for checking for `null` objects before accessing their attributes:

```javascript
var name = o && o.getName();
```

Or for caching values (when falsy values are invalid):
```javascript
var name = cachedName || (cachedName = getName());
```

JavaScript has a ternary operator for conditional expressions:
```javascript
var allowed = (age > 18) ? 'yes' : 'no';
```

### `switch`

The switch statement can be used for multiple branches based on a number or string:
```js
switch (action) {
  case 'draw':
    drawIt();
    break;
  case 'eat':
    eatIt();
    break;
  default:
    doNothing();
}
```

If you don't add a `break` statement, execution will "fall through" to the next level. This is very rarely what you want.

The default clause is optional. You can have expressions in both the switch part and the cases if you like; comparisons take place between the two using the === operator:
```js
switch (1 + 3) {
  case 2 + 2:
    yay();
    break;
  default:
    neverhappens();
}
```

## Objects

Similar to dictionaries in Python and Hash tables in C and C++.

There are two basic ways to create an empty object:
```js
var obj = new Object();
var obj2 = {};
```

```js
obj.for = 'Simon'; // Syntax error, because 'for' is a reserved word
obj['for'] = 'Simon'; // works fine
```

### Arrays

Arrays in JavaScript are actually a special type of object. They work very much like regular objects (numerical properties can naturally be accessed only using `[]` syntax) but they have one magic property called `length`. This is always one more than the highest index in the array.
```js
var a = new Array();
a[0] = 'dog';
a[1] = 'cat';
a[2] = 'hen';
a.length; // 3
```

If you query a non-existent array index, you'll get a value of undefined in return:
```js
typeof a[90]; // undefined
```

Other functions you can perform on Arrays.
``` js
a.push(item)    // Push value to the Array
a.toString()	// Returns a string with the toString() of each element separated by commas.
a.toLocaleString()	// Returns a string with the toLocaleString() of each element separated by commas.
a.concat(item1[, item2[, ...[, itemN]]])	// Returns a new array with the items added on to it.
a.join(sep)	// Converts the array to a string — with values delimited by the sep param
a.pop()	Removes and returns the last item.
a.push(item1, ..., itemN)	// Appends items to the end of the array.
a.shift()	// Removes and returns the first item.
a.unshift(item1[, item2[, ...[, itemN]]])	// Prepends items to the start of the array.
a.slice(start[, end])	// Returns a sub-array.
a.sort([cmpfn])	// Takes an optional comparison function.
a.splice(start, delcount[, item1[, ...[, itemN]]])	// Lets you modify an array by deleting a section and replacing it with more items.
a.reverse()	// Reverses the array.
```

### Functions

The rest parameter operator is used in function parameter lists with the format `...variable` and it will include within that variable the entire list of uncaptured arguments that the function was called with. We will also replace the for loop with a `for`...`of` loop to return the values within our variable.
```js
function avg(...args) {
  var sum = 0;
  for (let value of args) {
    sum += value;
  }
  return sum / args.length;
}

avg(2, 3, 4, 5); // 3.5
```

It is important to note that wherever the rest parameter operator is placed in a function declaration it will store all arguments after its declaration, but not before. i.e. `function avg(firstValue, ...args)` will store the first value passed into the function in the `firstValue` variable and the remaining arguments in `args`.

#### Spread syntax

Spread syntax (`...`) allows an iterable such as an array expression or string to be expanded in places where zero or more arguments (for function calls) or elements (for array literals) are expected, or an object expression to be expanded in places where zero or more key-value pairs (for object literals) are expected.
```js
function sum(x, y, z) {
  return x + y + z;
}

const numbers = [1, 2, 3];

console.log(sum(...numbers)); // expected output: 6
```

#### Anonymous functions

JavaScript lets you create anonymous functions — that is, functions without names. But such an anonymous function isn’t useful in isolation — because without a name, there’s no way to call the function. So in practice, anonymous functions are typically used as arguments to other functions or are made callable by immediately assigning them to a variable that can be used to invoke the function:
```js
var avg = function() {
  var sum = 0;
  for (var i = 0, j = arguments.length; i < j; i++) {
    sum += arguments[i];
  }
  return sum / arguments.length;
};
```

How do you call them recursively if they don't have a name? JavaScript lets you name function expressions for this. You can use named IIFEs (Immediately Invoked Function Expressions) as shown below:
```js
var charsInBody = (function counter(elm) {
  if (elm.nodeType == 3) { // TEXT_NODE
    return elm.nodeValue.length;
  }
  var count = 0;
  for (var i = 0, child; child = elm.childNodes[i]; i++) {
    count += counter(child);
  }
  return count;
})(document.body);
```

### Custom Objects
```js
function makePerson(first, last) {
  return {
    first: first,
    last: last,
    fullName: function() {
      return this.first + ' ' + this.last;
    },
    fullNameReversed: function() {
      return this.last + ', ' + this.first;
    }
  };
}

var s = makePerson('Simon', 'Willison');
s.fullName(); // "Simon Willison"
s.fullNameReversed(); // "Willison, Simon"
```

Note on the `this` keyword. Used inside a function, `this` refers to the current object. What that actually means is specified by the way in which you called that function. If you called it using dot notation or bracket notation on an object, _that_ object becomes `this`. If dot notation wasn't used for the call, `this` refers to _the global object_.

`this` can improve our Person constructor.
```js
function Person(first, last) {
  this.first = first;
  this.last = last;
  this.fullName = function() {
    return this.first + ' ' + this.last;
  };
  this.fullNameReversed = function() {
    return this.last + ', ' + this.first;
  };
}
var s = new Person('Simon', 'Willison');
```
We have introduced another keyword: `new`. `new` is strongly related to `this`. It creates a brand new empty object, and then calls the function specified, **with `this` set to that new object**. Notice though that the function specified with `this` does not return a value but merely modifies the `this` object. It's `new` that returns the `this` object to the calling site. Functions that are designed to be called by `new` are called __constructor functions__. Common practice is to capitalize these functions as a reminder to call them with `new`.

Our person objects are getting better, but there are still some ugly edges to them. Every time we create a person object we are creating two brand new function objects within it — wouldn't it be better if this code was shared?
```js
function personFullName() {
  return this.first + ' ' + this.last;
}
function personFullNameReversed() {
  return this.last + ', ' + this.first;
}
function Person(first, last) {
  this.first = first;
  this.last = last;
  this.fullName = personFullName;
  this.fullNameReversed = personFullNameReversed;
}
```
That's better: we are creating the method functions only once, and assigning references to them inside the constructor. Can we do any better than that? The answer is yes:
```js
function Person(first, last) {
  this.first = first;
  this.last = last;
}
Person.prototype.fullName = function() {
  return this.first + ' ' + this.last;
};
Person.prototype.fullNameReversed = function() {
  return this.last + ', ' + this.first;
};
```
`Person.prototype` is an object shared by all instances of `Person`. It forms part of a lookup chain (that has a special name, "prototype chain"): any time you attempt to access a property of `Person` that isn't set, JavaScript will check Person.prototype to see if that property exists there instead. As a result, anything assigned to `Person.prototype` becomes available to all instances of that constructor via the this object.

### Closures
This leads us to one of the most powerful abstractions that JavaScript has to offer — but also the most potentially confusing. What does this do?
```js
function makeAdder(a) {
  return function(b) {
    return a + b;
  };
}
var add5 = makeAdder(5);
var add20 = makeAdder(20);
add5(6); // ?
add20(7); // ?
```

The name of the makeAdder() function should give it away: it creates new 'adder' functions, each of which, when called with one argument, adds it to the argument that it was created with.

What's happening here is pretty much the same as was happening with the inner functions earlier on: a function defined inside another function has access to the outer function's variables. The only difference here is that the outer function has returned, and hence common sense would seem to dictate that its local variables no longer exist. But they do still exist — otherwise, the adder functions would be unable to work. What's more, there are two different "copies" of makeAdder()'s local variables — one in which a is 5 and the other one where a is 20. So the result of that function calls is as follows:
```js
add5(6); // returns 11
add20(7); // returns 27
```

A closure is the combination of a function and the scope object in which it was created. Closures let you save state — as such, they can often be used in place of objects.