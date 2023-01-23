#rust 

## Getting started

### Setup
[Setup guide](https://github.com/bevyengine/bevy/blob/main/docs/linux_dependencies.md#fedora) (necessary)
```sh
# Fedora
sudo dnf install gcc-c++ libX11-devel alsa-lib-devel systemd-devel
```

```sh
cargo new bevy-test
cargo add bevy
```

If you are using [Cargo Workspaces](https://doc.rust-lang.org/book/ch14-03-cargo-workspaces.html), you will also need to add the resolver to your Cargo.toml file in the root directory:
```toml
[workspace]
resolver = "2" # Important! wgpu/Bevy needs this!
```

While it may not be an issue for simple projects, debug builds in Rust can be _very slow_ - especially when you start using Bevy to make real games. Fortunately, there is a simple fix, and we don't have to give up our fast iterative compiles! Add this to your `Cargo.toml`:
```toml
# Enable a small amount of optimization in debug mode
[profile.dev]
opt-level = 1

# Enable high optimizations for dependencies (incl. Bevy), but not for our code:
[profile.dev.package."*"]
opt-level = 3
```

[(OPTIONAL) Enable fast compiles](https://bevyengine.org/learn/book/getting-started/setup/#enable-fast-compiles-optional)

## Apps
Bevy programs are referred to as `Apps`. The simplest Bevy app looks like this:
```rust
use bevy::prelude::*;

fn main() {
	App::new().run()
}
```
Nothing will happen since we haven't told the app to do anything yet. Apps are just empty shlles capable of running our application logic. We can add logic using Bevy ECS.

## ECS

For all app logic, Bevy uses the Entity Component System (ECS) paradigm. ECS is a software pattern that involves breaking your program up into **Entities**, **Components**, and **Systems**.
Entities are unique "things" that are assigned groups of Components, which are then processed using Systems

Example: an entity (A) might have a `Position` and `Velocity` component, whereas another (B) might have the `Position` and a `UI` component. Systems are logic that runs on a specific set of component types. You might have a `movement` system that runs on all entities with a `Position` and `Velocity` component.

A and B -> `Position`
also A -> `Velocity`
also B -> `UI`
`movement` system runs on entity A and others which run on `Position` and `Velocity`.

## Bevy ECS

Unlike other Rust ECS implementations which often require complex lifetimes, traits, builder patterns, or macros, the Bevy ECS simply uses normal Rust datatypes for all these concepts.

* Components: Rust structs that implement the Component trait:
```rust
#[derive(Component)]
struct Position { x: f32, y: f32 }
```
* Systems: normal Rust functions:
```rust
fn print_position_system(query: Query<&Transform>) {
	for transform in query.iter() {
		println!("position: {:?}", transform.translation);
	}
}
```
* Entities: a simple type containing a unique integer:
```rust
struct Entity(u64);
```

## In practice: 

### Your First System
```rust
use bevy::prelude::*;

// This will be our first system.
fn hello_world() {
	println!("hello world!");
}

use bevy::app::App;

// The only remaining step is to add it to our `App`!
// The `add_system()` function adds the system to your App's `Schedule`
fn main() {
	App::new()
	.add_system(hello_world)
	.run();
}
```

### Your First Components
```rust
use bevy::prelude::*;
use bevy::app::App;

// This is our first system from earlier.
fn hello_world() {
	println!("hello world!");
}

#[derive(Component)]
struct Person;
// In a more traditional design, we might just tack on a `name: String field` 
// to Person. But other entities might have names too! 
// It often makes sense to break datatypes up in to small pieces to encourage 
// code reuse. So let's make Name its own component:
#[derive(Component)]
struct Name(String);


// We can then add People to our `World` using a "startup system". Startup 
// systems are just like normal systems, but they run exactly once, before all 
// other systems, right when our app starts. Let's use Commands to spawn some 
// entities into our `World`:
fn add_people(mut commands: Commands) {
    commands.spawn((Person, Name("Elaina Proctor".to_string())));
    commands.spawn((Person, Name("Renzo Hume".to_string())));
    commands.spawn((Person, Name("Zayna Nieves".to_string())));
}

// System that properly greets the new citizens of our `World`
fn greet_people(query: Query<&Name, With<Person>>) {
    for name in query.iter() {
        println!("hello {}!", name.0);
    }
}

// We add the startup system using `add_startup_system()`
// add_people system would run first, followed by hello_world then greet_people
fn main() {
    App::new()
	    .add_startup_system(add_people)
	    .add_system(hello_world)
	    .add_system(greet_people)
	    .run();
}
// Quick Note: "hello world!" might show up in a different order than it does above. 
// This is because systems run in parallel by default whenever possible.
```

## Plugins

Bevy has modular plugins. All engine features are implemented as plugins. Even games themeselves are implemented as plugins! This empowers developers to pick and choose which features they want. Don't need a UI? Don't register `UiPlugin`. Want a headless server? Don't register `RenderPlugin`.

Can replace default plugins with your own. However, most developers don't need a custom experience and just want the "full engine" experience with no hassle. For this, Bevy provides a set of "default plugins".

### Bevy's default plugins

`add_plugins(DefaultPlugins)` adds the features that most people expect from an engine such as 2D/3D renderer, asset loading, a UI sytem, windows, and input.
```rust
fn main() {
    App::new()
        .add_plugins(DefaultPlugins)
        .add_startup_system(add_people)
        .add_system(hello_world)
        .add_system(greet_people)
        .run();
}
```

Note that `add_plugins(DefaultPlugins)` is equivalent to the following:
```rust
fn main() {
    App::new()
        .add_plugin(CorePlugin::default())
        .add_plugin(InputPlugin::default())
        .add_plugin(WindowPlugin::default())
        /* more plugins omitted for brevity */
        .run();
}
```

You should hopefully notice two things:
-   **A window should pop up**. This is because we now have [`WindowPlugin`](https://docs.rs/bevy_window/latest/bevy_window/struct.WindowPlugin.html) , which defines the window interface (but doesn't actually know how to make windows), and [`WinitPlugin`](https://docs.rs/bevy_winit/latest/bevy_winit/struct.WinitPlugin.html) which uses the [winit library](https://github.com/rust-windowing/winit) to create a window using your OS's native window api.
-   **Your console is now full of "hello" messages**: This is because [`DefaultPlugins`](https://docs.rs/bevy/latest/bevy/struct.DefaultPlugins.html) adds an "event loop" to our application. Our App's ECS Schedule now runs in a loop once per "frame". We will resolve the console spam in a moment.

### Your First Plugin

For better organization, let's move all the "hello" logic to a plugin. To create a plugin, we simply need to implement the `Plugin` interface.
```rust
pub struct HelloPlugin;

impl Plugin for HelloPlugin {
	fn build(&self, app: &mut App) {
		app.add_startup_system(add_people)
			.add_system(hello_world)
			.add_system(greet_people);
	}
}

fn main() {
    App::new()
        .add_plugins(DefaultPlugins)
        .add_plugin(HelloPlugin)
        .run();
}
```

## Resources
Entities and Components are great for representing complex, query-able groups of data.

But most apps will also require "globally" unique data of some kind. In Bevy ECS, we represent globally unique data using **Resources**

Examples of Resources:
- Elapsed time
- Asset colletions (sounds, textures, and meshes)
- Renderers

### Tracking Time with Resources

Let's solve our App's "hello spam" problem by only printing "hello" once every two seconds. We'll do this by using the [`Time`](https://docs.rs/bevy_core/latest/bevy_core/struct.Time.html) resource, which is automatically added to our App via `add_plugins(DefaultPlugins)`.

For simplicity, remove the `hello_world` system from your App. This way we only need to adapt the `greet_people` system.

Resources are accessed in much the same way that we access components.
```rust
fn greet_people(time: Res<Time>, query: Query<&Name, With<Person>>) {
    for name in query.iter() {
        println!("hello {}!", name.0);
    }
}
```

`Res` and `ResMut` pointers provide read and write access (respectively) to resources.
The `delta` field on `Time` gives us the time that has passed since the first update.
We must track the amount of time that has passed over a series of updates. To make this easier, Bevy provides the `Timer` type.
```rust
#[derive(Resource)]
struct GreetTimer(Timer);

fn greet_people(
    time: Res<Time>, mut timer: ResMut<GreetTimer>, query: Query<&Name, With<Person>>) {
    // update our timer with the time elapsed since the last update
    // if that caused the timer to finish, we say hello to everyone
    if timer.0.tick(time.delta()).just_finished() {
        for name in query.iter() {
            println!("hello {}!", name.0);
        }
    }
}
```

Now all that's left is adding a `GreetTimer` Resource to our `HelloPlugin`. Use `TimerMode::Repeating` to make the timer repeat.
```rust
impl Plugin for HelloPlugin {
    fn build(&self, app: &mut App) {
			app.insert_resource(GreetTimer(Timer::from_seconds(2.0, TimerMode::Repeating)))
            .add_startup_system(add_people)
            .add_system(greet_people);
    }
}
```

## Next steps
[Next steps resources](https://bevyengine.org/learn/book/next-steps/)

Bevy unoffical cheat book is great allegedly

