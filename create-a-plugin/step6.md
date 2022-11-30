# Publish our plugin


## Commit the changes 

Add the files and commit the changes:

```
git add .
git commit -m 'feat: initial foobar plugin'
git push
```

_NOTE: you will need your github credentials here_

To release, we simply need to:

* Bump the `VERSION` in the `Makefile`. It's currently set to `0.0.1` which is appropriate.
* Tag the project `git tag -a v0.0.1 -m "Initial release"`{{exec}}
* Push the tag `git push origin v0.0.1`{{exec}}

That's it! There is a `release.yml` in the github workflows directory that will automatically build and publish the artifact to GitHub.

## Check the release step

We can download the `pact-plugin-cli` now to see if it can:

`curl -fsSL https://raw.githubusercontent.com/pact-foundation/pact-plugins/main/scripts/install-plugin-cli.sh | bash`{{exec}}

Install your plugin, using the CLI, customised to your git repo:

```
/root/bin/pact-plugin-cli install -y github.com/YOURPROJECT/pact-foobar/plugin
```{{copy}}

Check if it's installed:

`/root/bin/pact-plugin-cli list`{{exec}}

