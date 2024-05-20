# React 18
#javascript #react #html

## Components

Pieces of functional code that can be used to build elements on the page. Components allow us to break down complex UIs to make large codebases easier to maintain and scale.

Historically, classes were used for components, but now components are almost always functions.

Components can have _props_, attributes, passed in and can hold their own _state_

## State

State represents the data that a component manages internally. This could be form input data, fetched data, UI-related data, etc.

There is also the global state, which relates to the app as a whole and not a single component. Useful when you don't want to pass state down through other components

## Hooks

React functions that enable functional components to use state and other features.

Hooks can only be called at the top level of the component or your own custom hook.

### `useState`

`useState` lets you add a state variable to your component.

`useState` accepts an initial value and returns an array containing the current state value of the variable and the __set__ function to update that state.

```js
const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
```

#### Updating state via passing update functions

Updating the state based on the previous state is not as simple as:
```js
function handleClick() {
  setAge(age + 1); // setAge(42 + 1)
  setAge(age + 1); // setAge(42 + 1)
  setAge(age + 1); // setAge(42 + 1)
}
```
The `set` function does not update the state variable in the already running code. You can pass an updater function to the `setAge` instead of the next state. The update function takes the pending state to calculate the next state from it. Example:
```js
function handleClick() {
  setAge( a => a + 1); // setAge(42 => 43)
  setAge( a => a + 1); // setAge(43 => 44)
  setAge( a => a + 1); // setAge(44 => 45)
}
```

#### Replace objects, don't mutate!

In React, state is considered read-only, so you should replace objects and arrays rather than mutating existing objects! For example, instead of:
```js
form.firstName = 'Taylor';
```
Replace the form entirely:
```js
setForm({
  ...form,
  firstName: 'Taylor'
});
```

#### Initializer function: Avoid recreating initial state

You should avoid recreating the intial state. React stores it once and ignores it on successive renders:
```js
function TodoList() {
  const [todos, setTodos] = useState(createInitialTodos());
  // ...
}
```
Although this value is only being used for the intial render, you're still calling the function every render, which is wasteful! To solve this, you may pass the function itself as an initializer function:
```js
function TodoList() {
  const [todos, setTodos] = useState(createInitialTodos); // Function passed, not invoked to pass return value!
  // ...
}
```

#### Resetting state with the `key` attribute

The `key` attribute in lists allows you to uniquely identify a list item among other list items. It can serve another purpose: resetting a component's state by passing a different `key` to the component.

```js
import { useState } from 'react';

export default function App() {
  const [version, setVersion] = useState(0);

  function handleReset() {
    setVersion(version + 1);
  }

  return (
    <>
      <button onClick={handleReset}>Reset</button>
      <Form key={version} />
    </>
  );
}

function Form() {
  const [name, setName] = useState('Taylor');

  return (
    <>
      <input
        value={name}
        onChange={e => setName(e.target.value)}
      />
      <p>Hello, {name}.</p>
    </>
  );
}
```

Here we the Reset button resets the Form component by modifying the app's `version` state variable. The Form is initialized with `key={version}` so changes to `version` recreate the Form.

#### Storing information from previous renders

Usually, you will update state in event handlers. However, in rare cases you may want to adjust the state in response to rendering. For example, you may want to change a state variable when a prop changes.

In most cases, you don't need this:
- If the value you need can be computed entirely from the current props or other state. You can remove that redundant state altogether. If you're worried about recomputing too often, the `useMemo` hook can help.
- If you want to reset the entire component tree's state, pass a different `key` to your component.
- If you can, update all the relevant state in the event handlers.

In the rare case that none of these apply, there is a pattern that you can use to update the state based on the values that have been rendered so far: Call a `set` function while your component is rendering. Example:
```js
export default function CountLabel({ count }) {
  return <h1>{count}</h1>
}
```
Let's say we want to show whether the count has increased or decreased. We add a state variable called `trend` and update it by performing a comparison of `count` with another state variable `prevCount`.
```js
import { useState } from 'react';

export default function CountLabel({ count }) {
  const [prevCount, setPrevCount] = useState(count);
  const [trend, setTrend] = useState(null);

  if (prevCount !== count) {
    setPrevCount(count);
    setTrend(count > prevCount ? 'increasing' : 'decreasing');
  }

  return (
    <>
      <h1>{count}</h1>
      {trend && <p>The count is {trend}</p>}
    </>
  );
}
```

You can only call `set` function while rendering if you're inside a condition block like above. Otherwise, the component would re-render ad infitum until it crashes. Also you can only update the state of the currently rendering component. Calling a `set` function of another component while rendering is an error. Finally, your `set` function should remain pure-- still update the state without mutation.

### `useEffect`

`useEffect` allows us to synchronize a component with an external system, e.g. fetching data from a server on load. External systems are any pieces of code that are not controlled by React, such as:
- An application running on another server
- A timer managed with `setInterval()` and `clearInterval()` (DOM API)
- An event subscription using `window.addEventListener()` and `window.removeEventListener()` (DOM API)
- A third-party animation library with an API like `animation.start()` and `animation.reset()`

If you're not trying to sync with an external system, you probably don't need an effect. 

`useEffect` accepts two arguments:
1. The setup function with setup code that connects to the system
    - The setup function should return a cleanup function with cleanup code that disconnects from the system. 
2. The list of dependencies which includes every value from your component used inside of those functions.

```js
import { useEffect } from 'react';
import { createConnection } from './chat.js';

function ChatRoom({ roomId }) {
  const [serverUrl, setServerUrl] = useState('https://localhost:1234');

  useEffect(() => {  // the setup function that is passed
    const connection = createConnection(serverUrl, roomId);  // the setup code
    connection.connect();
    return () => {  // the cleanup function that is returned
      connection.disconnect(); // the cleanup code
    };
  }, [serverUrl, roomId]); // the list of dependencies
  // ...
}
```

React calls the setup and cleanup functions whenever it's necessary, which may happen multiple times. It may call it when:

1. Your setup code runs when the component is added to the page (mounts).
2. After every re-render of your component where the dependencies have changed.
    1. First your cleanup code runs with the old props and state
    2. Then, your setup code runs with the new props and state.
3. Your cleanup runs a final time after your component is removed from the page (unmounts).

### `useRef`

`useRef` lets you reference a value that's not needed for rendering. 
```js
const ref = useRef(initialValue);
```

Unlike props that have state, __changing a ref does not trigger a re-render__. Refs are not appropriate for storing information that should be displayed on screen, so use `useState` for that instead. `useState` is recommended for most cases. See [differences](https://react.dev/learn/referencing-values-with-refs#differences-between-refs-and-state).

Changing a ref has to happen via setting its `current` attribute:
```js
import { useRef } from 'react';

function Stopwatch() {
  const intervalRef = useRef(0);
  // ...
}

function handleStartClick() {
  const intervalID = setInterval(() => {
    // ...
  }, 1000);
  intervalRef.current = intervalId;
}
```

Reading the value from the ref is also done via `current`.
```js
function handleStopClick() {
  const intervalId = intervalRef.current;
  // DOM API: cancel timed, repeated action established by setInterval
  clearInterval(intervalId);
}
```

### `useReducer`

`useReducer` lets you add a reducer, or function that allows state to be managed through `dispatch()`ing actions, to a component. 

For example, your component may have many functions which call a prop setter function to modify the state.
```js
export default function TaskApp() {
  const [tasks, setTasks] = useState(initialTasks);
  
  function handleAddTask(text) {
    setTasks([
      ...tasks,
      {
        id: nextId++,
        text: text,
        done: false,
      },
    ]);
  }
  
  function handleChangeTask(task) {
    setTasks(
      tasks.map((t) => {
        if (t.id === task.id) {
          return task;
        } else {
          return t;
        }
      })
    );
  }
  
  function handleDeleteTask(taskId) {
    setTasks(tasks.filter((t) => t.id !== taskId));
  }

  return (
    <>
      <h1>Prague itinerary</h1>
      <AddTask onaddTask={handleAddTask} /> // Button
      <TaskList
        tasks={tasks}
        onChangeTask={handleChangeTask}
        onDeleteTask={handleDeleteTask}
      />
    </>
  );
}

let nextId = 3;
const initialTasks = [
  {id: 0, text: 'Visit Kakfa Museum', done: true},
  //...
];
```

We can replace all `setTasks` calls with a reducer! `useReducer` accepts a reducer function and an initial state. It returns the stateful value and a dispatch function which "dispatches" user actions to the reducer. Actions can have any shape you define!
```js
import { useReducer } from 'react';

export default function TaskApp() {
  const [tasks, dispatch] = useReducer(tasksReducer, initialTasks);
  
  function handleAddTask(text) {
    dispatch({
      type: 'added',
      id: nextId++,
      text: text,
    });
  }

  function handleChangeTask(task) {
    dispatch({
      type: 'changed',
      task: task,
    });
  }

  function handleDeleteTask(taskId) {
    dispatch({
      type: 'deleted',
      id: taskId,
    });
  }

  return (<>
    // Same stuff
  </>);
}

function taskReducer(tasks, action) {
  switch(action.type) {
    case 'added': {
      return [
        ...tasks,
        {
          id: action.id,
          text: action.text,
          done: false,
        },
      ];
    }
    case 'changed': {
      return tasks.map((t) => {
        if (t.id === action.task.id) {
          return action.task;
        } else {
          return t;
        }
      })
    }
    case 'deleted': {
      tasks.filter((t) => t.id !== action.id);
    }
    default: {
      throw Error('Unknown action ' + action.type);
    }
  }
}

// And finally, the same initialization as before
// ...
```

In general, `useState` requires less code and is easier to read for simple cases of modifying state.`useReducer` can be a better choice than `useState` when there are many functions that modify state. Reducers can be good for debugging and readability too.

Just as state updaters, reducers run during rendering (actions are queued until the next render). Reducers must be *pure*, the same input should always result in the same output. They shouldn't send requests, schedule timeouts, or perform and side effects (operations that impact things outside the component). They should update objects and arrays without mutations.

Each action should describe a single user interaction, even if it leads to multiple changes in the data. For example, if a user presses "Reset" on a form with five fields managed by reducer, it makes more sense to dispatch one `reset_form` action rather than five separate `set_field` actions. If you log every action in a reducer, the log should be clear enough for you to reconstruct what interactions or responses happened in what order. This is helpful for debugging!

### Other hooks

React 19 is coming soon. It will phase out `useContext`, `useMemo`, and `useCallback`.

You can also write custom hooks to do anything! The hook should follow the convention of starting with the word `use`.

## JSX

HTML-like syntax extension within Javascript that can be returned by a React component.

HTML and JSX are not 1-for-1 in their syntax. Some examples:
- JSX has to use `className` as `class` is a reserved keyword in JS.
- HTML's `for` attribute in `<label>` and `<output>` is replaced in JSX with `htmlFor`.

Unlike HTML, JSX also requires:
- Content to be returned within a root element, i.e. enclose everything within a <div> or another parent tag.
- All tags must be closed, either by a closing tag or self-closing tag
- camelCase for attributes, see above paragraph.

JSX properties aka "props" are essentially the same thing as HTML attributes. They're more powerful in that they can accept JS expressions.

Passing JS variables or non-string values to JSX tag attributes or tag text can be done with curly braces immediately after the `=` operator:
```js
today = new Date();

function formatDate(date) {
    // ...
}

export default function TodoList() {
  return (
    <img className="avatar" src={avatar} alt={description} />
    <p>Date: {formatDate(today)}</p>
  );
}
```

### Conditionally returning JSX 

If statements can help control which JSX you render:
```js
if (isPacked) {
  return null;
} else {
  return (
    <li className="item">
      {name}
    </li>
  );
}
```
Returning `null` will not render anything at all.

You can use the logical AND operator `&&` to only render JSX if the condition is `true`:
```js
return (
  <li className="item">
    {name} {isPacked && <b>- PACKED</b>}
  </li>
);
```

Likewise you can use the ternary operator:
```js
return (
  <li className="item">
    {name} - {isPacked ? <i>packed</i> : <b>NOT PACKED</b>}
  </li>
);
```

You can also bind JSX to a JS variable and include it inside of other JSX using curly braces.
```js
list = null;
if (!isPacked) {
  name = <i>{firstName} {lastName}</i>
  list = (
    <li className="item">
      {name} - Not packed!
    </li>
  );
}
return list;
```
