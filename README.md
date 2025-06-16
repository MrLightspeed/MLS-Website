# Git Integration & Wix CLI <img align="left" src="https://user-images.githubusercontent.com/89579857/185785022-cab37bf5-26be-4f11-85f0-1fac63c07d3b.png">

This repo is part of Git Integration & Wix CLI, a set of tools that allows you to write, test, and publish code for your Wix site locally on your computer.

Connect your site to GitHub, develop in your favorite IDE, test your code in real time, and publish your site from the command line.

## Set up this repository in your IDE

This repo is connected to a Wix site. That site tracks this repo's default branch. Any code committed and pushed to that branch from your local IDE appears on the site.

Before getting started, make sure you have the following things installed:

- [Git](https://git-scm.com/download)
- [Node](https://nodejs.org/en/download/), version 22 (run `nvm use` to load the version in `.nvmrc`).
- [npm](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm) or [yarn](https://yarnpkg.com/getting-started/install)
- An SSH key [added to your GitHub account](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account).

To set up your local environment and start coding locally, do the following:

1. Open your terminal and navigate to where you want to store the repo.
1. Clone the repo by running `git clone <your-repository-url>`.
1. Navigate to the repo's directory by running `cd <directory-name>`.
1. Install the repo's dependencies by running `npm install` or `yarn install`.
1. Install the Wix CLI by running `npm install -g @wix/cli` or `yarn global add @wix/cli`.  
   Once you've installed the CLI globally, you can use it with any Wix site's repo.

For more information, see [Setting up Git Integration & Wix CLI](https://support.wix.com/en/article/velo-setting-up-git-integration-wix-cli-beta).

## Write Velo code in your IDE

Once your repo is set up, you can write code in it as you would in any other non-Wix project. The repo's file structure matches the [public](https://support.wix.com/en/article/velo-working-with-the-velo-sidebar#public), [backend](https://support.wix.com/en/article/velo-working-with-the-velo-sidebar#backend), and [page code](https://support.wix.com/en/article/velo-working-with-the-velo-sidebar#page-code) sections in Editor X.

Learn more about [this repo's file structure](https://support.wix.com/en/article/velo-understanding-your-sites-github-repository-beta).

## Test your code with the Local Editor

The Local Editor allows you test changes made to your site in real time. The code in your local IDE is synced with the Local Editor, so you can test your changes before committing them to your repo. You can also change the site design in the Local Editor and sync it with your IDE.

Start the Local Editor by navigating to this repo's directory in your terminal and running `wix dev`.

For more information, see [Working with the Local Editor](https://support.wix.com/en/article/velo-working-with-the-local-editor-beta).

## Preview and publish with the Wix CLI

The Wix CLI lets you preview and publish the site from the command line. Run `wix preview` to generate a preview link locally. Use `wix publish` to publish once your changes pass the CI gate. You can also use the CLI to install [approved npm packages](https://support.wix.com/en/article/velo-working-with-npm-packages) to your site.

## Local commands

- `npm run lint` runs ESLint with zero warnings allowed.
- `npm run format` formats files with Prettier.
- `npm run prettier:check` verifies formatting without writing changes.

Learn more about [working with the Wix CLI](https://support.wix.com/en/article/velo-working-with-the-wix-cli-beta).

## Automated preview workflow

This repo includes a GitHub Actions workflow that installs the Wix CLI and builds a preview of your site whenever code is pushed to the `main` branch. To enable it, add a `WIX_CLI_TOKEN` secret in your repository settings so the workflow can authenticate with your Wix site.

The preview URL is posted on each pull request. A follow-up workflow checks Lighthouse performance and accessibility scores and optimizes images. Publishing to production requires approving the `Publish` workflow once these checks pass.

## Asset optimisation

Run `npx squoosh-cli <file>` on any images inside `src/public` to manually compress them. The CI workflow will attempt the same optimisation and commit changes when the total size is reduced by more than 5%.

## Invite contributors to work with you

Git Integration & Wix CLI extends Editor X's [concurrent editing](https://support.wix.com/en/article/editor-x-about-concurrent-editing) capabilities. Invite other developers as collaborators on your [site](https://support.wix.com/en/article/inviting-people-to-contribute-to-your-site) and your [GitHub repo](https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-personal-account-on-github/managing-access-to-your-personal-repositories/inviting-collaborators-to-a-personal-repository). Multiple developers can work on a site's code at once.

## Local preview

Run `wix preview` to generate a shareable link for the current branch. The Preview workflow posts this link on each pull request after running `npm audit`.

## Continuous integration

Pull requests must pass linting and formatting checks. The Quality Gate workflow runs Lighthouse and axe-core to enforce performance and accessibility scores above 90 and compresses images automatically. Production deploys require approving the Publish workflow once these checks succeed. An asset-size workflow guards JS and CSS bundle growth while CodeQL checks for high severity vulnerabilities on each pull request.

## Security

See [SECURITY.md](SECURITY.md) for how to report vulnerabilities.
