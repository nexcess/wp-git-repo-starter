# Sample WordPress Git Repository

This repository shows how to structure a WordPress/WooCommerce site under version control with git, including sensible defaults.

This repository is designed to be the `wp-content/` directory of your WordPress site, using [Composer](https://getcomposer.org) to pull in external dependencies (including plugins and themes).


## Features

This template provides the following features:

* A `.gitignore` file pre-configured to exclude plugins and themes by default.
* A `composer.json` file pre-configured to load plugins and themes into their appropriate directories via [WPackagist](https://wpackagist.org).
* `index.php` files for provided directories, ensuring poorly-configured servers don't provide a directory listing.


## Usage

Get started by cloning this repository into your local environment:

```sh
$ git clone git@github.com:nexcess/wp-git-repo-starter.git
```

Next, run the bundled `refresh-repo.sh` script to clean up the template's own git history, leaving you with a clean start:

```sh
$ bash ./bin/refresh-repo.sh
```

Just like that, you have a fresh directory and clean git history!

### Moving an existing site under version control

If you have a local copy of your site you wish to move under version control, we recommend you do the following:

```sh
# Clone this repository adjacent to your current wp-content directory.
$ git clone git@github.com:nexcess/wp-git-repo-starter.git wp-git-repo-starter

# Copy over select files from the template into your wp-content directory.
$ cp -nr wp-git-repo-starter/{.editorconfig,index.php,plugins,themes,uploads} wp-content \
  && cp -n wp-git-repo-starter/composer.json.example wp-content/composer.json

# Finally, remove the template as it's no longer needed.
rm -rf wp-git-repo-starter
```

That command will copy over the relevant files from the example repository without overwriting anything that doesn't already exist in your `wp-content/` directory.


### Adding a new (internal) plugin or theme

If your site has custom plugins and/or themes, you'll want to make sure that these directories are actually tracked by the repository.

This can be accomplished by modifying the `.gitignore` file and adding your path, prefixed with an exclamation mark ("!"), which negates the previously matched pattern(s).

For example, if your site has a custom plugin in `plugins/my-cool-plugin`, you'd add the following to your `.gitignore` file:

```
!plugins/my-cool-plugin
```


### Adding a new (external) plugin or theme

The repository template is pre-configured to load external plugins and themes from [WPackagist](https://wpackagist.org), which makes all WordPress.org plugins and themes available for installation via Composer.

```sh
# Install Jetpack and the Twenty Twenty theme.
$ composer require wpackagist-plugin/jetpack:* wpackagist-theme/twentytwenty:*
```

If needed, you may declare a specific version of a plugin or theme, but `*` will should pull in the latest stable release.

#### Dealing with premium plugins and themes

If you're running premium plugins and/or themes that are not available via WordPress.org, you have several options:

1. Treat the premium plugin/theme as internal and, as updates are available, commit those changes:
	```text
	$ wp plugin update <some-premium-plugin>
	$ git add plugins/some-premium-plugin
	$ git commit -m "Updated Some Premium Plugin to version x.y.z"
	```

2. Create a private repository on the service of your choice to use as a mirror of the premium plugin:
	```text	
	$ cp -r /path/to/premium-plugin /path/to/private/mirror
	$ cd /path/to/private/mirror
	$ git add . && git commit -m "Version x.y.z"
	$ git tag vX.Y.Z
	$ git push && git push --tags
	```

You may also reach out an ask the plugin developer if they offer a Composer repository for the package; as more and more WordPress developers are leveraging Composer, it's becoming increasingly common for the premium providers to offer private Composer repos.


## Resources

If you're new to Git or version control in general, the following are excellent starting points to understand the core concepts:

* [What is Git?](https://help.nexcess.net/77285-other/what-is-git)
* [Introduction to Git](https://blog.nexcess.net/introduction-to-git/)
* [Advanced Git Usage and Workflows](https://blog.nexcess.net/advanced-git-usage-workflows/)
* [The Top 5 Git Best Practices For Success](https://www.liquidweb.com/kb/the-top-5-git-best-practices-for-success/)
* [From zero to Git for WordPress teams](https://www.branchci.com/learn/git-for-wordpress) by Branch
