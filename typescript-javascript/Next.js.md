#react #typescript #webdev

Framework for building React apps

## Setup

prereqs: `node`, `nvm`, `npm`, `yarn` (optional)

Create a new NextJS project:
`yarn create next-app --typescript`
(say yes to esLint)
`cd <project dir>`

Run on development server:
`yarn dev` and visit [http://localhost:3000](http://localhost:3000)

## Packages
Followed this [video guide](https://www.youtube.com/watch?v=ZO70nxbnS0k)
`yarn add -D` is for adding developer dependencies!

### Prettier to enforce style
`yarn add -D prettier eslint-config-prettier`
`vim .prettierrc.json` and add:
```json
{
	"printWidth": 80,
	"semi": true,
	"singleQuote": true,
	"tabWidth": 2,
	"trailingComma": "es5"
}
```

### eslint rules for typescript (a bit stricter than default and we include Prettier):
`yarn add -D @typescript-eslint/eslint-plugin`
`vim .eslintrc.json` and change to:
```json
{
  "env": {
    "browser": true,
    "es2021": true,
    "node": true
  },
  "extends": ["next/core-web-vitals", "plugin:@typescript-eslint/recommended", "prettier"], // make sure prettier is last
  "settings": {
    "react": {
      "version": "detect"
    }
  }
}
```

###  TailwindCSS with PostCSS  + AutoPrefixer
postcss: tool to transform css using various javascript plugins (linters, etc.)
autoprefixer: PostCSS plugin to help with vendor-specific (browser) prefixes

`yarn add -D tailwindcss@latest postcss@latest autoprefixer@latest`
`npx tailwindcss init -p` creates config files

Modify `tailwind.config.js`:
```json
/** @type {import('tailwindcss').Config} */
module.exports = {
  purge: [ // remove unused styles to optimize build
    './src/pages/**/*.{js,ts,jsx,tsx}',
    './src/components/**/*.{js,ts,jsx,tsx}',
  ],
  darkMode: false, // whether to support
  //content: [],
  theme: { // define color pallete/font type etc.
    extend: {},
  },
  variants: { // which variants are generated for each core utility plugin
    extend: {},
  },
  plugins: [], // register other tailwindCSS plugins
}
```

#### Enabling tailwindCSS
Can either:  
1) add the following header to styles/global.css to replace styles at build time.  
```css 
@tailwind base;
@tailwind components;
@tailwind utilities;
```
OR  
2) delete global.css and Home.modules, remove references to these files in the typescript code, and add the following import ``_app.tsx`:
```ts
import 'tailwindcss/tailwind.css';
```

[part 2 of guide](https://www.youtube.com/watch?v=7iVL7b0L4xc)

