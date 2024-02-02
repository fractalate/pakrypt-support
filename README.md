# Pakrypt Support

Tools and information to support deploying and operating an instance of Pakrypt.

## QA Process

Read the supporting material:

* [www.pakrypt.com](https://www.pakrypt.com/)
* [www.pakrypt.com/guide.html](https://www.pakrypt.com/guide.html)
* [README.md](https://github.com/fractalate/pakrypt)
* [Developers.md](https://github.com/fractalate/pakrypt/blob/main/doc/Developers.md)
* [Release.md](https://github.com/fractalate/pakrypt/blob/main/doc/Release.md)
* Help tile.

Test everything mentioned by the material.

## Deployment Checklist

Pre-flight:

* Is the help tile updated?
* Is the README updated?
* Is the developer documentation updated?
* Is the guide updated?
* Is the web front updated?
* Is QA good?

Release:

* Determine the next release version number (adhere to semver `v1.0.0`).
* Merge all relevant branches into `main`.
* Draft commits on `main` adding the following:
  - `LICENSE`
    - Updated copyright.
  - `package.json`
    - Updated copyright.
    - Updated version number.
  - `package-lock.json` (run `npm install .`)
    - Updated version number.
  - `README.md`
    - Updated version number.
  - `doc/Release.md`
    - Release summary.
* Tag the `main` branch with the final release version `v1.0.0`.
* Manage GitHub release.
  - Do a fresh install and build, .tar.gz it up.
  - Put the file in the release.
  - Validate the link to the release works in `README.md`.
* Run the app deploy script with the version tag, e.g. `./deploy-app.sh v1.0.0`.
* Verify the version by using the app.

### Tips

* Give a couple days of time between completing the development work and the release.
* Prepare the release summary a couple days before the release.

## Pre-release Deploys

To deploy Pakrypt to [app.pakrypt.com/pakrypt.version:prerelease](https://app.pakrypt.com/pakrypt.version:prerelease), use the `deploy-app.sh` script.

```bash
./deploy-prerelease-app.sh git-tag-to-deploy
```

## Production Deploys

To deploy Pakrypt to [app.pakrypt.com](https://app.pakrypt.com/), use the `deploy-app.sh` script.

```bash
./deploy-app.sh git-tag-to-deploy
```

To deploy web front for Pakrypt to [www.pakrypt.com](https://www.pakrypt.com/), use the `deploy-www.sh` script.

```bash
./deploy-www.sh git-tag-to-deploy
```

## Bug Rundown

* [ ] Exporting my online pak on mobile isn't importable. "Can't load file."
