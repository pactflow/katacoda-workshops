# Publish our plugin

Now we are going to publish our plugin so that anybody may use it.

Let's open our plugin project once again:

`cd ~/pact-plugin-template-golang`{{exec}}

## Configure Git

Prepare Git for use, replace the values below with your email and name:

```
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
```{{copy}}

### Create a fine grained personal access token

head to https://github.com/settings/personal-access-tokens/new

* Give it a name and description (e.g. Pact Plugin tutorial)
* Set expiration to something short (like 7 days)
* Choose "only select repositories" and select your plugin project
* Under "repository permissions" choose read and write for "Contents"
* Choose "generate token" and copy the value

## Commit the changes 

Add the files and commit the changes:

```
git add .
git commit -m 'feat: initial foobar plugin'
git push
```

_NOTE: you will need to use your personal access token as the password in this step_

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

