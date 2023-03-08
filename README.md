## Raise plugin update PRs automatically

**:warning: This is only for Github.**

#### Motive of the project

For WordPress plugin updates in large sites, sometimes its quite hectic to raise update plugin for each of the individual plugins. Although we can combine all the updates in a single PR, but this is not recommended keeping in mind maintainability perspective. Because suppose any of the plugin updates breaks the site. So, if all the updates are in the same PR and we have to revert that PR then all the plugin updates will be gone and we will have no way to know which plugin update caused the site to break.

So, because of this its recommended to raise each PR separately. But if the number of plugins to be updated are too large, i.e suppose 50+, then it will be quite hectic and time consuming.

And there's where this script comes into play.

#### How it works

- This script creates separate branch for each of the plugin updates with very specific name (`update-plugin/<plugin_name>-<lower_version>-<upper_version>`). This branch name will ensure we will not have any conflict in branch name in future.
- After that it updates the plugin in that particular branch. And then commits that change.
- After that it pushed the change to github and raises a PR against branch you mentioned while executing the script. See below for more details on how to use it.

#### Pre-requisites

- GH cli installed on your system.
- GH CLI authenticated on your system.
- WP CLI installed on your system.
- `unzip` command installed on your system.

#### How to use it

- Clone the repository to your system.
- Make sure you have write access to the repo.
- Authenticate to your GH CLI if you haven't already.
- Copy this script to your `wp-content` directory.
- Run `./update-plugins.sh <prefix> <base_branch>`. The second argument is for any prefix you want to give to the wp cli command. For example if you are using Lando as your local development setup. Then you have to use wp cli commands with `lando` at its beginning. e.g - `lando wp plugin list`, etc. So, in that case you have to pass `lando` as the prefix.
- Now your PRs will be created in the Github repo. And then you can just merge those PRs.

#### Some important notes

- If you have a branch named as above, with those same versions as the versions involve in this iteration of update. Then that plugin will be skipped.

