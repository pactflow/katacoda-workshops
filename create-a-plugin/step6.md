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
git push origin master
```

_NOTE: you will need to use your personal access token as the password in this step_

To release, we simply need to:

* Bump the `VERSION` in the `Makefile`. It's currently set to `0.0.1` which is appropriate.
* Tag the project `git tag -a v0.0.1 -m "Initial release"`{{exec}}
* Push the tag `git push origin v0.0.1`{{exec}}

That's it! There is a `release.yml` in the github workflows directory that will automatically build and publish the artifact to GitHub.

## Check the release step

Head over to your GitHub Actions build page for your repo (https://github.com/YOUR_ORG/pact-foobar-plugin/actions). You should see the release job is running (it should take about 3-4 mins to execute).

Once it's completed, it will create a number of release artifacts that are ready to be downloaded by your users!

In fact, they are prepared in a way that can also be installed through the Plugin CLI. Let's download the CLI and install it that way:

`curl -fsSL https://raw.githubusercontent.com/pact-foundation/pact-plugins/main/scripts/install-plugin-cli.sh | bash`{{exec}}

Install your plugin, using the CLI, customised to your git repo:

```
/root/bin/pact-plugin-cli install -y https://github.com/YOUR_ORG/pact-foobar-plugin/releases/tag/v0.0.1
```{{copy}}

Check if it's installed:

`/root/bin/pact-plugin-cli list`{{exec}}

You can now head back to your JS tests and try running again to see if it works:

```
cd ~/example-project-js-foobar-plugin
npm t
```{{exec}}

```
...
Verifying a pact between myconsumer and myprovider

  an HTTP request to /foobar
     Given the Foobar protocol exists
    returns a response which
      has status code 200 (OK)
      includes headers
        "content-type" with value "application/foo" (OK)
      has a matching body (OK)
```

WOOT! 🎉

## Adding plugins to the global Plugin registry

Your plugin is currently available to anybody to download and use, however you can make it even easier by registering it with the Pact Plugin Repository.

The `pact-plugin-cli` has a built-in index of known plugins which can be installed by name. For example, to install the
Protobuf plugin, run `pact-plugin-cli install protobuf` and it will know how to download that plugin from the index.

You can add entries to the index using the `pact-plugin-cli repository` commands. The index files are checked in to
https://github.com/pact-foundation/pact-plugins/tree/main/repository. So the steps to add a new plugin or plugin 
version are (using the [AVRO plugin](https://github.com/austek/pact-avro-plugin) as an example):

1. Fork and clone the https://github.com/pact-foundation/pact-plugins repo.
2. You can list the current index and also validate it with:
```console
❯ pact-plugin-cli repository list repository/repository.index
┌──────────┬──────────┬────────────────┬──────────┐
│ Key      ┆ Name     ┆ Latest Version ┆ Versions │
╞══════════╪══════════╪════════════════╪══════════╡
│ csv      ┆ csv      ┆ 0.0.3          ┆ 4        │
├╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌┤
│ protobuf ┆ protobuf ┆ 0.3.0          ┆ 29       │
└──────────┴──────────┴────────────────┴──────────┘

❯ pact-plugin-cli repository validate repository/repository.index
'/home/ronald/Development/Projects/Pact/pact-plugins/repository/repository.index' OK

┌────────────────┬──────────────────────────────────────────────────────────────────┬─────────────────────────────────────────────┐
│ Key            ┆ Value                                                            ┆                                             │
╞════════════════╪══════════════════════════════════════════════════════════════════╪═════════════════════════════════════════════╡
│ Format Version ┆ 0                                                                ┆                                             │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┤
│ Index Version  ┆ 5                                                                ┆                                             │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┤
│ Last Modified  ┆ 2023-03-10 05:36:45.725083896 UTC                                ┆ Local: 2023-03-10 16:36:45.725083896 +11:00 │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┤
│ Plugin Entries ┆ 2                                                                ┆                                             │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┤
│ Total Versions ┆ 33                                                               ┆                                             │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┤
│ SHA            ┆ d41450c9849112b08a8633c27893ac2ec0e9fe958e0861e570083da7b307ad56 ┆                                             │
└────────────────┴──────────────────────────────────────────────────────────────────┴─────────────────────────────────────────────┘
```
3. Add a new entry for the plugin. You can also get it to scan the GitHub project to add all versions.
```console
❯ pact-plugin-cli repository add-plugin-version git-hub repository/repository.index https://github.com/austek/pact-avro-plugin/releases/tag/v0.0.3
Added plugin version avro/0.0.3 to repository file '/home/ronald/Development/Projects/Pact/pact-plugins/repository/repository.index'

❯ pact-plugin-cli repository list repository/repository.index
┌──────────┬──────────┬────────────────┬──────────┐
│ Key      ┆ Name     ┆ Latest Version ┆ Versions │
╞══════════╪══════════╪════════════════╪══════════╡
│ avro     ┆ avro     ┆ 0.0.3          ┆ 1        │
├╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌┤
│ csv      ┆ csv      ┆ 0.0.3          ┆ 4        │
├╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌┤
│ protobuf ┆ protobuf ┆ 0.3.0          ┆ 29       │
└──────────┴──────────┴────────────────┴──────────┘
```
4. Then commit the changed files and create a PR back to the https://github.com/pact-foundation/pact-plugins project.

Once the PR is accepted, your plugin will be available for download by name.