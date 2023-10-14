[Tutorials by Logic Projects on YT](https://www.youtube.com/watch?v=_uKWIYEGBjs)

```toml
[package]
name = "bevy_tut"
version = "0.1.0"
edition = "2021"

# Enable a small amount of optimization in debug mode
[profile.dev]
opt-level = 1
# Enable high optimizations for dependencies (incl. Bevy), but not for our code:
[profile.dev.package."*"]
opt-level = 3

[dependencies]
# **Enable Bevy's Dynamic Linking Feature**: 
# This is the most impactful compilation time decrease! 
# If `bevy` is a dependency, you can compile the binary with the "dynamic" feature flag (enables dynamic linking).
# NOTE: Remember to revert this before releasing your game!
bevy = { version = "0.9.1", features = ["dynamic"] }
```

**LLD linker**: The Rust compiler spends a lot of time in the "link" step. LLD is _much faster_ at linking than the default Rust linker. To install LLD, find your OS below and run the given command:
`dnf install lld`
Mold linker is also an option (5x faster than LLD but less platform support).
`dnf install mold`

## Basic 3D Scene

Function parameters to a system function must be SystemParams.

The SystemParam Commands. Commands let us spawn/despawn entities, add/remove Components to Entities, and add/remove Resources from the App. Commands are executed after the game update logic runs, but before rendering occurs. So if you spawn something with a command, it will be rendered without any delay. But if you want to access the spawned components, you will either need to access them after the `CoreStage::Update` stage (for the current frame), or wait until next frame.

Component bundles: "templates" that make it easy to create entities with a common set of components. From unofficial cheat sheet:
```rust
#derive(Bundle)
struct PlayerBundle {
	xp: PlayerXp,
	name: PlayerName,
	health: Health,
	_p: Player,

	// We can nest/include another bundle.
	// Add the components for a standard Bevy Sprite:
	#[bundle]
	sprite: SpriteSheetBundle
}
```

An entity can only have one copy of an associated Component, e.g. cannot have two separate sprites.

Assets: tracked objects. map of handleids to underlying data.
Handles are a lightweight handle to the Asset that you can use as a Component