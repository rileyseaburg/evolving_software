# Evolving Software

This project now serves the Evolving Software site with **TetherScript HTTP** instead of the previous Rust/Actix server.

## Getting Started

### Requirements

- `tetherscript` installed and available on `PATH`
- Node/Yarn for TailwindCSS asset generation

### Run the TetherScript HTTP server

```bash
yarn server
```

This runs:

```bash
tetherscript run --grant-fs . server.tether
```

The server listens on:

```text
http://127.0.0.1:8787/
```

### Development mode

```bash
yarn dev
```

This starts the TetherScript server and watches TailwindCSS files.

### Static check

```bash
yarn server:check
```

This parses/inspects `server.tether` without starting the HTTP listener.

## Routes

- `GET /` — marketing homepage
- `GET /login` — login form
- `POST /login` — prototype cookie-backed login flow
- `GET /dashboard` — authenticated dashboard
- `GET /logout` — clears the prototype session cookie
- `/static/*`, `/robots.txt`, `/favicon.ico` — static files served through TetherScript filesystem capability

## Notes

The old Rust/Actix source remains in `src/` for reference, but `yarn server` and `yarn dev` now use `server.tether`.

## License

This project is licensed under the MIT License.
