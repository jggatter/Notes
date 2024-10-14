# Next.js
#javascript #typescript

Next.js is a React frontend development web framework that
enables functionality such as server-side rendering (SSR) and
static site generation. It's intended for large, production applications.

It was created by Vercel, a cloud platform as a service company.

## Features

### Server-side rendering (SSR)

Traditional React apps aka Single Page Applications (SPA) have the entire application loaded and
rendered on the client (web browser).
Browser request gets redirected through a single HTML file which calls and loads your JavaScript.

This provides a more interactive user interface than conventional web applications
where each interaction generally can cause the the backend to compile data and possibly use templating to deliver formatted HTML files.

SPA apps tend to be bad for Search Engine Optimization (SEO) as the client-loaded JavaScript doesn't render semantic HTML that can be understood by search engine crawlers.
With SSR such as Next.js, the first page is rendered server-side as HTML and directly delivered, giving interactive interfaces that are beneficial for SEO.

### Routing

With traditional React apps we'd have to define these ourselves using `react-router-dom`.
With Next.js, in our pages folder we can create a JavaScript file that exports a component and this page will automatically be rendered when visited as a route.

Dynamic parameters (e.g. `/someroute/<someid>`) are supported provided that the pages are structured in a certain way.

API routes can be created directly within the Next.js file structure.
This allows backends using frameworks such as Express.js, other programming languages, or headless CMS.

### Other

- Out of the box Typescript by changing file extensions to `.ts`/`.tsx`
- Out of the box CSS Sass by changing file extensions to `.scss`
- Static site generation (Really fast websites that don't need backend, just a CDN)
- Easy deployment (on anything that supports Node.js, such as Vercel)


## Getting started

Can set up via `npx create-next-app <new project name>`. Deno supports this too.
This installs `react`, `react-dom`, and `next`.

A project with the following gets created:
- `package.json` with project metadata, dependencies, and tasks defined
- pages folder for routes 
  - `index.js` can contain the home page component
  - `_app.js`: contains a function that wraps all page components
  - `api` folder
- public folder with publically accessible assets like the `favicon.ico`, images, and (if preferred) style sheets
- styles folder to contain style sheets
  - globals.css contains CSS to be used across the application but not directly within a component page
  - It can be common to have css files specific to modules, e.g. `Home.module.css`

A components folder can be created to store "non-page" components.

`next dev`: start the development server
`next build`: build the production application
`next start`: run the production application build

When run locally, the server can be accessed at [localhost:3000]()

### Example

`index.js` at the route [/](http://localhost:3000/)
```JavaScript
import Head from 'next/head'; // For defining metadata

export default function Home() {
  return (
    <div>
      <Head>
        <title>WebDev News</title>
        <meta name='keywords' content='web development, programming'/>
      </Head>

      <h1>Welcome to Next</h1>
    </div
  )
}
```

`about.js` at [/about](localhost:3000/about)
```JavaScript
import Head from 'next/head';

const about = () => {
  return (
    <div>
      <Head>
        <title>About</title>
      </Head>
      <h1>About</h1>
    </div>
  )
}

export default about;
```

`_app.js`:
```JavaScript
import '../styles/globals.css'; 

function MyApp({ Component, pageProps }) {
  // Could add a header or footer that would wrap each page component!
  return <Component {...pageProps} />
}

export default MyApp;
```

### Applying styles

As mentioned we can store components that aren't to be rendered as pages in `components/`

We can apply styles by importing a style sheet, e.g.
`styles/Layout.module.css`:
```css
.container {
  min-height: 100vh;
  padding: 0 0.5rem;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  align-items: center;
}

.main {
  padding: 5rem 0;
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  align-items: center;
  font-size: 1.25rem;
}
```

and inputting a style class to the `className` property. 
`components/Layout.js`:
```javascript
import styles from '../styles/Layout.module.css'

const Layout = ({children}) => {
  return (
    <div className={styles.container}>
      <main className={styles.main}>
        { children }
      </main>
    </div>
  )
}
```

Th styled component can then be used to wrap every page component:
`pages/_app.js`:
```javascript
import Layout from '../components/Layout'
import '../styles/globals.css'; 

function MyApp({ Component, pageProps }) {
  // We've added a component that wraps every page component!
  return (
    <Layout>
      <Component {...pageProps} />
    </Layout>
  )
}

export default MyApp;
```

## Links

Let's create a `Nav` component in `components/Nav.js`:
```javascript
import Link from 'next/link'
import navStyles from '../styles/Nav.module.css'

const Nav = () => {
  return (
    <nav className={navStyles.nav}>
      <ul>
        <li>
          <Link href='/'>Home</Link>
        </li>
        <li>
          <Link href='/about'>About</Link>
        </li>
      </ul>
    </nav>
  )
}
```

`components/Layout.js`:
```javascript
import Nav from './Nav'
import styles from '../styles/Layout.module.css'

const Layout = ({children}) => {
  return (
    <> // Use a JSX Fragment here so that we return a single parent component
      <Nav/>
      <div className={styles.container}>
        <main className={styles.main}>
          { children }
        </main>
      </div>
    </>
  )
}
```

### Header

Let's make a Header component to add to Layout.

`components/Header.js`:
```javascript
import headerStyles from '../styles/header.module.css'

const Header = () => {
  var x = 5; 
  return (
    <div>
      <h1 className={'title'}>
        <span>WebDev</span> News
      </h1>
      <style jsx> // Can be messy to do this
        {`
          .title {
            color: ${x > 3 ? 'red' : 'blue'};
          }
        `}
      </style>
      <p className={headerStyles.description}>
        Keep up to date with the latest Web dev news
      </p>
    </div>
  )
}
```

`components/Layout.js`:
```javascript
import Nav from './Nav'
import Header from './Header'
import styles from '../styles/Layout.module.css'

const Layout = ({children}) => {
  return (
    <> // Use a JSX Fragment here so that we return a single parent component
      <Nav/>
      <div className={styles.container}>
        <main className={styles.main}>
          <Header />
          { children }
        </main>
      </div>
    </>
  )
}
```

## Custom `Document`

A custom `Document` can be defined to augment an application's `<html>` and `<body>` attributes.

This is necessary because Next.js pages skip the definition of the surrounding document's markup.

To override the default `Document`, create the file `./pages/_document.js` and `extend` the `Document` class. See the documentation for how to override the default.

The default basically looks like this:
```js
// ...
render () {
  return (
    <Html>
      <Head />
      <body>
        <Main />
        <NextScript />
      <body>
    </Html>
  )
}
// ...
```

For example we could modify `<Html>` to have the property `lang='en'`.

## Fetching data

There are three methods for fetching data:
- `getStaticProps`: Fetch at build-time
- `getServerSideProps`: Fetch on every request (slower)
- `getStaticPaths`: Generate paths based on data fetched

Let's add `getStaticProps` to the bottom of `pages/index.js`:
```JavaScript
import Head from 'next/head'; // For defining metadata

export default function Home({articles}) {
  return (
    <div>
      <Head>
        <title>WebDev News</title>
        <meta name='keywords' content='web development, programming'/>
      </Head>

      <h1>Welcome to Next</h1>

      <ArticleList articles={articles}/>
    </div
  )
}

export const getStaticProps = async () => {
  const res = await fetch(`https://jsonplaceholder.typicode.com/posts?_limit=6`)
  const articles = await res.json()

  return {
    props: {
      articles
    }
  }
}
```

We define `ArticleItem` and `ArticleList` components.
In `ArticleItem`, we define a nested route via `Link`.

`components/ArticleItem.js`:
```JavaScript
import Link from 'next/link'
import articleStyles from '../styles/article.module.css'

export default const ArticleItem = ({ article }) => {
  return (
    <Link href="/article/[id]" as={`/article/${article.id}`}>
      <a className={articleStyles.card}>
        <h3>{article.title} &rarr;</h3>
        <p>{article.body></p>
      </a>
    </Link>
  )
}
```

`components/ArticleList.js`:
```JavaScript
import ArticleItem from './ArticleItem'
import articleStyles from '../styles/article.module.css'

export default const ArticleList = ({ articles }) => {
  return (
    <div className={articleStyles.grid}>
      {articles.map((article) => (
        <ArticleItem article={article} />
      ))}
    </div>
  )
}
```

We now make and edit the following path `pages/article/[id]/index.js`:
```JavaScript
import {useRouter} from 'next/router'

export default const article = () => {
  const router = useRouter()
  const {id} = router.query

  return <div>This is an article {id}</div>
}
```
Or:
```JavaScript
import Link from 'next/link'

export default const article = ({article}) => {
  return (
    <>
      <h1>{article.title}</h1>
      <p>{article.body}</p>
      <br />
      <Link href='/'>Go back</Link>
    </>
  )
}

export const getServerSideProps = async (context) => {
  const res = await fetch(
    `https://jsonplaceholder.typicode.com/posts/${context.params.id}`
  )
  const article = await res.json()
  
  return {
    props: {
      article
    }
  }
}
```

A combination of `getStaticProps` and `getStaticPaths` could be used instead to dynamically generate the paths with the data.

```JavaScript
import Link from 'next/link'

export default const article = ({article}) => {
  return (
    <>
      <h1>{article.title}</h1>
      <p>{article.body}</p>
      <br />
      <Link href='/'>Go back</Link>
    </>
  )
}

export const getStaticProps = async (context) => {
  const res = await fetch(
    `https://jsonplaceholder.typicode.com/posts/${context.params.id}`
  )
  const article = await res.json()
  
  return {
    props: {
      article
    }
  }
}

export const getStaticPaths = async (context) => {
  // We request all of the posts
  const res = await fetch(
    `https://jsonplaceholder.typicode.com/posts`
  )
  const articles = await res.json()
  
  const ids = articles.maps(article => article.id)
  const paths = ids.map(id => ({params: {id: id.toString()}}))
  return {
    paths: paths,
    fallback: false // If we do not find article then we return 404
  }
}
```
