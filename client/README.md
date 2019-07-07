# Client side

- [`main`](./main) — Redux state configuration and actions. Common application components.
- [`lib`](./lib) — shared React components and utility functions library.
- [`packs`](./packs) — Webpack entry points.

Pages:

- [`about`](./about) — about page.
- [`feed`](./feed) — individual feed page.
- [`index`](./index) — root page with the feeds list and activity graph.
- [`posts`](./posts) — posts list page.
- [`updates`](./updates) — updates page.

See also:

- Webpack configuration: [/config/webpacker.yml](../config/webpacker.yml)
- Root stylesheet: [/client/main/style.scss](./main/style.scss)
- Customized Bootstrap CSS: [/client/main/bootstrap.scss](./main/bootstrap.scss)
- Rails route helpers: [/client/main/paths.js.erb](./main/paths.js.erb)
- Client-side routing: [/client/main/routes.js](./main/routes.js)
- Redux state configuration: [/client/main/store.js](./main/store.js)
