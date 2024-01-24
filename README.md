# Pakrypt Support

Tools and information to support deploying and operating an instance of Pakrypt.

## Deployment Checklist

### Tips

* Give a couple days of time between completing the development work and the release.
* Prepare the release summary a couple days before the release.

### Release Candidate

When there are some changes which will need to be released, start by creating a release candidate version.

* Determine the next release version number (adhere to semver `v1.0.0`).
* Create a release candidate branch from `main` (format `v1.0.0-rc1`).
* Merge all relevant branches into the release candidate branch.
* Draft commits to add the following:
  - The release candidate version number in `package.json`.
  - The release candidate version number in `package-lock.json` (run `npm install .`).
  - A release summary tagged with the final release version in `doc/Release.md`.

The release candidate may then be distributed for testing.

### Release

After testing, the release can be created.

* Draft commits on the release candidate branch to add the following:
  - The final release version number in `package.json`.
  - The final release version number in `package-lock.json` (run `npm install .`).
* Merge the release candidate branch into `main`, creating a merge commit (`git merge --no-ff v1.0.0-rc1`).
* Tag the `main` branch with the final release version `v1.0.0`.
* Run the APP deploy script with the version tag, e.g. `./deploy-app.sh v1.0.0`.

## Deploy Scripts

To deploy Pakryp to [app.pakrypt.com](https://app.pakrypt.com/), use the `deploy-app.sh` script.

```bash
./deploy-app.sh git-tag-to-deploy
```

To deploy web front for Pakrypt to [www.pakrypt.com](https://www.pakrypt.com/), use the `deploy-www.sh` script.

```bash
./deploy-www.sh git-tag-to-deploy
```
