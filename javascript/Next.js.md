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


## Getting started with Next.js 10

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
The static pages are then generated for all of the posts.

### Exporting a static site

The pages could then be exported:
```sh
next build && next export
```
The static website will be located in the `out/` directory.
The content could then be served:
```sh
# sudo npm i -g serve
serve -s out -p 8000
# Now visit localhost:8000 in the browser
```

## API routes

`pages/api/articles/index.js`:
```js
import { articles } from '../../../data'

export default function handler(req, res) {
    res.status(200).json(articles)
}
```
[https://localhost:3000/api/articles](https://localhost:3000/api/articles) will return all the articles!

Let's change it.
`pages/api/articles/index.js`:
```js
import { articles } from '../../../data'
import { server } from '../config'

export default function handler({query: {id}}, res) {
    const filtered = articles.filter(article => articles.id === id)
    if (filtered.length < 0) {
        res.status(200).json(filtered[0]) // First article
    } else{
        res.status(404).json({message: `Article of id ${id} not found`}))
    }
}

export const getStaticProps = async () => {
    // The URL needs to be absolute so we define server in the config/index.js
    const res = await fetch(`${server}/api/articles`)
    const articles = await res.json()

    return {
        props: {
            articles,
        },
    }
}
```

`config/index.js`
```JavaScript
const dev = process.env.NODE_ENV !== 'production'

export const server = dev ? 'http://localhost:3000' : 'https://yourwebsite.com'
```

We can then change the front end page to pull from this endpoint:
`pages/article/[id]/index.js`:
```JavaScript
import Link from 'next/link'
import { server } from '../../../config'

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

// Could alternatively use getStaticProps and getStaticPaths
export const getServerSideProps = async (context) => {
  const res = await fetch(
    `${server}/api/articles/${context.params.id}`
  )
  const article = await res.json()
  
  return {
    props: {
      article
    },
  },
}
```

## Custom Meta components

Recall:
`pages/index.js`
```JavaScript
import Head from 'next/head'; // For defining metadata

export default function Home({articles}) {
  return (
    <div>
      <Head>
        <title>WebDev News</title>
        <meta name='keywords' content='web development, programming'/>
      </Head>

      <ArticleList articles={articles}/>
    </div
  )
}
```

What if we want to make `Head` a part of the `Layout` so we don't have to repeat it everywhere:
`components/Meta.js`:
```JavaScript
import Head from 'next/head'

const Meta = ({title, keywords, description}) => {
  return (
    <Head>
      <meta name='viewport' content='width=device-width, initial-scale=1' />
      <meta name='keywords' content={keywords} />
      <meta name='description' content={description} />
      <meta charSet='utf-8' />
      <link rel='icon' href='/favicon.ico'
      <title>{title}</title>
    </Head>
  )
}

Meta.defaultProps = {
  title: 'WebDev Newz',
  keywords: 'web development, programming',
  description: 'Get the latest news in web dev',
}
```

Add it to layout:
`components/Layout.js`:
```JavaScript
import Meta from './Meta'
import Nav from './Nav'
import Header from './Header'
import styles from '../styles/Layout.module.css'

const Layout = ({children}) => {
  return (
    <>
      <Meta/>
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
And remove the `Head` import from `pages/index.js` and all other pages.
```JavaScript
export default function Home({articles}) {
  return (
    <div>
      <ArticleList articles={articles}/>
    </div
  )
}
```

Overriding it on a page can be done as such:
`about.js`
```JavaScript
import Meta from '../components/Meta'

const about = () => {
  return (
    <div>
      <Meta title='About' />
      <h1>About</h1>
    </div>
  )
}

export default about
```

## Next.js 13

I believe these are Brad Traversy's new recommended practices:

- React files that contain JSX end with `.jsx` and not `.js`
- Page components should be suffixed with `Page`
- Semi-colon terminators

Not sure if these are Next.js 13 differences?
- `app/globals.css` contains global CSS

### Routing

The `pages/` folder no longer does the automatic routing for each module file.

Home page is `app/page.jsx` and not `pages/index.js`
```JavaScript
import Link from 'next/link';

const HomePage = () => {
  return (
    <div>
      <h1>Welcome</h1>
      <ul>
        <li><Link href='/'>Home</Link></li>
        <li><Link href='/'>About</Link></li>
        <li><Link href='/'>Team</Link></li>
      </ul>
    </div>
  );
};

export default HomePage;
```
Note: `Link` objects have `href` property and no longer can contain anchor attributes.

We create a dir  within `app/` for each page contained within a `page.jsx` module.

For example, `app/about/page.js` contains:
```JavaScript
const AboutPage = () => {
  return (
    <div>
      <h1>About</h1>
      <p>Lorem Ipsum</p>
    </div>;
  )
};
```

We can nest routes within these folders:
`app/about/team/page.jsx`:
```JavaScript
const TeamPage = () => {
  return (
    <div>
      <h1>Team</h1>
      <p>Lorem Ipsum</p>
    </div>
  );
}
```
Which is located at [localhost:3000/about/team].

## Layouts

The `app/layout.jsx` contains a `RootLayout` object that wraps everything.
```javascript
import './globals.css';

// We now define metadata here instead of Meta
export const metadata = {
  title: 'Traversy Media',
  description: 'Web Development Tutorials',
  keywords: 'web development, programming',
};

export default function RootLayout({ children }) {
  return (
    <html lang='en'>
      <body>{children}</body>
    </html>
  );
}
```

Creating a `layout.jsx` within a route folder can override the layout of the route and nested routes:
`app/about/layout.jsx`:
```javascript
export const metadata = {
  title: 'About Traversy Media',
}

const AboutLayout = ({ children }) => {
  return (
    <div>
      <h1>THIS IS THE ABOUT LAYOUT</h1>
      {children}
    </div>
  );
};

export default AboutLayout;
```
We can also override `metadata` on pages by `export`ing it as above.


### Importing fonts

We can import fonts in the layout:
```javascript
import { Poppins } from 'next/font/google';
import './globals.css';

const poppins = Poppins({
  weight: ['400'],
  subsets: ['latin'],
});

export default function RootLayout({ children }) {
  return (
    <html lang='en'>
      <body className={poppins.className}>
        <main className='container'>
          {children}
        </main>
      </body>
    </html>
  );
}
```

## components

We still can put non-page components into `app/components`, e.g. `Header.jsx`:
```javascript
const Header = () => {
  return (
    <header className="header">
      <div className="container">
        <div className="logo">
          <Link href="/">Traversy Media</Link>
        </div>
        <div className="links">
          <Link href="/about">About</Link>
          <Link href="/about/team">Our Team</Link>
          <Link href="/code/repos">Code</Link>
        </div>
      </div>
    </header>
  );
};

export default Header;
```
Then add that to the layout.

## React Server vs. Client Components

By default, components created will be rendered on the server.

Benefits of React Server Components:
- They load faster since we don't need to wait for JavaScript to load
- Smaller client bundle size
- SEO friendly
- Access to resources that the client can't access!
- Hide sensitive data from the client!
- More secure against cross-site scripting (XSS) attacks
- Improved developer experience

Disadvantages of React Server Components:
- Not as interactive
- No component state, cannot use `useState` hook
- No component lifecycle methods, cannot use `useEffect` hook

A client component can be marked at the top of the module with a line:
```javascript
'use client';
...
```

Fetching data with a server component:
`app/code/repos/page.jsx`:
```javascript
async function fetchRepos() {
  const response = await fetch('https://api.github.com/users/bradtraversy/repos');
  await new Promise((resolve)) => setTimeout(resolve, 1000)); // Mock loading time

  const repos = await response.json();
  return repos;
}

const ReposPage = async () => {
  const repos = await fetchRepos();

  return (
    <div>
      // ... Render the output
    </div>
  )
}

export default ReposPage;
```

`app/loading.jsx` is automatically displayed during page wait times!
```JavaScript
export default const LoadingPage = () => {
  return (
    <div className="loader">
      <div className="spinner"></div>
    </div>
  );
}
```

### Dynamic routing

`app/code/repos/[name]/page.jsx`:
```JavaScript
import Repo from '@/app/component/Repo';

const RepoPage = ({ params: {name} }) => {
  return (
    <div className='card'>
      <Repo name={name}/>
    </div>
  );
};

export default RepoPage;
```

`app/components/Repo.jsx`:
```JavaScript
async function fetchRepo() {
  const response = await fetch(`https://api.github.com/users/bradtraversy/${name}`);
  const repo = await response.json();
  return repo;
}

const Repo = async = ({ name }) => {
  const repo = fetchRepo(name);
  return (
    <div>Repo</div>
  );
}

export default Repo;
```

Visiting [localhost:3000/code/repos/myrepo]() will dynamically fetch and render.

### Suspense boundaries

As seen in earlier with `app.loading.jsx`, the whole page will not render until the data is fetched.

We can use suspense boundaries to only have specific components await rendering and let everything else load.

```JavaScript
import { Suspense } from 'react';

// ...
return (
  <>
    // ...
    <Suspense fallback={<div>Loading repo...</div>}>
      <Repo name={name} />
    </Suspense>
    <Suspense fallback={<div>Loading repo directories...</div>}>
      <RepoDirs name={name} />
    </Suspense>
    // ...
  </>
)
```

### Caching data

By default in production builds, `fetch` will cache everything indefinitely.
This is great for performance but can cause issues if what's being fetched
is being changed often

In previous versions, we had `getStaticProps`/`getStaticPaths` (static sites)
and `getServerSideProps` (fetch anew every request).
TODO: Are these no longer used?

We have a `revalidate` option in `fetch` that is an object:
```js
async function fetchRepo() {
  const response = await fetch(
    `https://api.github.com/users/bradtraversy/${name}`,
    {
      next: {
        revalidate: 60, // cache for 60 seconds
      },
    }
  );
  const repo = await response.json();
  return repo;
}
```
