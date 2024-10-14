# Deno
#javascript #typescript 


## Initialize and configure

Initialize a new project via:
`deno init <project folder>`

The `deno.json` file is created to configure the project.
A `main.ts` and a `main_test.ts` are created.

### VSCode

The Deno extension is installable.
The command `Deno: Initialize Workspace Configuration` will
configure Deno for workspace with the following `.vscode/settings.json`:
```json
{
    "deno.enable": true,
    "deno.lint": true
}
```

### Shell

bash or zsh completions can be enabled, see the documentation.

## Run and test

`deno`: Enter the Deno REPL

`deno run main.ts`: Run main.ts
`deno run <URL>`: Run a file located at a URL.
`deno run --allow-net server.ts`: Run a file allowing HTTP connections.
`cat main.ts | deno run -`: Run code through pipe to stdin.

`deno test`: Run tests located within test files
`deno test --doc`: Run tests that test markdown code blocks with JSDoc docstrings.

`deno check main.ts`: Type-check Typescript files without executing.
`deno run --check main.ts`: Type-check and execute.

### Watch

The built-in file watcher enables automatic reloading of your
application whenever changes are detected in the source files.

The `--watch` flag can be used with `run`, `test`, `fmt`, or `compile`.  
`--watch-exclude=<path1>,<path2>,<...>` can be used to exclude files from being watched.

### Script arguments

Pass arguments to script:
```sh
deno run main.ts arg1 arg2 arg3
```
Log arguments passed to the script:
```javascript
console.log(Deno.args)
> [ "arg1", "arg2", "arg3" ]
```

## Module metadata

[Documentation](https://docs.deno.com/runtime/tutorials/module_metadata/#concepts)

`import.meta.main` is a boolean that determines whether this current module is the entrypoint.
Similar to Python's `__name__ == '__main__'`.

## NPM Compatibility

Deno has multiple options that enable more or less compatibility with NPM.

- Maybe you can just import the package via a `npm:` import specifier and the package will just work.
- Maybe you need a `package.json` for the package to work.
- Maybe you need a `node_modules` directory for the package to work.

Different packages might have different requirements to work in Deno. 

### Import via `npm:`

Example of importing a npm package via `npm:`:
```javascript
// npm:<package-name>[@<version-requirement>][/<sub-path>]
import * as emoji from "npm:node-emoji";

console.log(emoji.emojify(`:sauropod: :heart:  npm`));
```

There's no need to `npm install` before `deno run`. Even still,
you can substitute the following npm install command:
```sh
npm install --save-exact react@rc react-dom@rc
```
with:
```sh
deno install npm:react@rc npm:react-dom@rc
```

### Permissions

The packages are also subject to the same permissions as
other code in Deno, where access to file systems, network
connectivity, the environment, etc. must be explicitly granted.
`deno` flags such as `--allow-read`, `--allow-write`, `--allow-net`,
`--allow-env`, `--allow-run`, and `--allow-all` permit access.
`--deny-...` flags conversely disallow access and take precedence.

### Support for `package.json`

Deno also supports a `package.json` file for compatibility with
Node.js projects.
If you have a Node.js project, creating a `deno.json` isn't
necessary and Deno will use the existing `package.json`.
If both files are present, Deno will understand both and use 
the `deno.json` for Deno-specific configurations.

### Support for `node_modules`

No `node_modules` folder is created by default. In cases where 
an npm package expects itself to be running from a
`node_modules` directory, the `--node-modules-dir` flag can
be used to create a `node_modules` in the current directory with
a similar folder structure to npm. For example:
```javascript
import chalk from "npm:chalk@5";

console.log(chalk.green("Hello"));
```
```sh
deno run --node-modules-dir main.ts
```
Outputs:
```
node_modules
├── .bin
├── .deno
│   ├── .deno.lock
│   ├── .deno.lock.poll
│   ├── .setup-cache.bin
│   ├── chalk@5.3.0
│   │   ├── .initialized
│   │   └── node_modules
│   │       └── chalk
│   │           ├── license
│   │           ├── package.json
│   │           ├── readme.md
│   │           └── source
│   │               └── ...
│   └── node_modules
└── chalk -> .deno/chalk@5.3.0/node_modules/chalk

```

### Node to Deno cheatsheet

Node.js     	    Deno
node file.js 	    deno file.js
ts-node file.ts 	deno file.ts
nodemon 	        deno run --watch
node -e 	        deno eval
npm i / npm install deno install
npm install -g  	deno install -g
npm run 	        `deno task`
eslint 	            deno lint
prettier 	        deno fmt
package.json 	    deno.json or package.json
tsc 	            deno check¹
typedoc 	        deno doc
jest, etc.          deno test
nexe / pkg 	        deno compile
npm explain 	    deno info
nvm / n / fnm 	    deno upgrade
tsserver 	        deno lsp
nyc, etc.           deno coverage
benchmarks 	        deno bench
