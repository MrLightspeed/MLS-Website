# MLS Website Repository Guidelines

## Environment Setup
- Use Node.js 18 via `nvm use` (see `.nvmrc`).
- Install dependencies with `npm install`.
- Install Wix CLI globally with `npm install -g @wix/cli`.

## Development Workflow
- Run `npm run dev` to open the local Wix Editor.
- Run `npm run lint` before committing.

## CI/CD
- The GitHub Actions workflow `.github/workflows/wix-cli.yml` builds a preview of the site using the Wix CLI.
- Configure the `WIX_CLI_API_KEY` secret in GitHub for authentication.

