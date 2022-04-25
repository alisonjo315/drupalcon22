# New copy of demo site

Instsructions for creating a new Drupal 9 site on Pantheon, with the Drupal
config entities from the demo site.

Note: We _have_ adapted these steps to create non-Pantheon sites from our demo site.

## Make a new site!

### Prerequisites

* A Pantheon site to use as your "demo site" (a site you'll clone).
* [git](https://git-scm.com/) (installed on your local machine)
* A terminal program (I have coworkers who've done it on Windows, and certainly
Macs -- I've only done it in Ubuntu)
* Pantheon (this process doesn't require any specific service level, I haven't
tried it with a free Pantheon account, but I cant think of any reason it wouldn't
work?)
  * As previously mentioned, we've adapted these steps to create non-Pantheon sites.
* [Terminus](https://pantheon.io/docs/terminus)
  * A colleague who didn't have Terminus installed, was able to do the process
  with Lando, and the Terminus instacne "within" their lando environment.
* Also, y'know, you need a site to clone :)

### Step 1: Clone repo to local machine

First, I clone the demo site repo from Pantheon, and remove the `git` directory,
so I can initiize a new git repo for my new site:
```
$ git clone ssh://blahblahblah/repository.git newsite
$ cd newsite
$ rm -rf .git
$ git init
```
Tip: Depending on the specs of the new site, sometimes I create a multidev of
our demo site, remove functionality I won't be needing (i.e. if the site doesn't
need "news," I would remove the news content type and view), and create the new
site from that branch. In such cases, I set up my new site repo like this:
```
$ git clone ssh://blahblahblah/repository.git newsite
$ cd newsite
$ git checkout multidev-branch-name
$ rm -rf .git
$ git init
```

### Step 2: Create new site on Pantheon

Next, I use terminus to create a new site on Pantheon:
```
$ terminus site:create --org ORG_ID newsite "NEW SITE HUMAN NAME" empty
```
FYI:
* The new site won't "be" anything, it'll be a plain/nothing site.
* `org` is an identifier on Pantheon<br>
* `empty` means the new site will have an "empty upstream" in Pantheon.

### Step 3: Push local repo to new Pantheon site

Then, I force-push my new copy of the demo site repo to the new Pantheon site:
```
$ terminus connection:info newsite.dev --field=git_url
$ git remote add origin PANTHEON_GIT_URL
$ terminus connection:set newsite.dev git
$ git add .
$ git commit -m "first commit"
$ git push origin master --force
```
* 'connection:set' is necessary because newly created Pantheon sites are in SFTP
mode by default.
* I have to use `--force` because the remote site repo has alredy been initialized.

### Step 4: Install Drupal with "existing config"

Finally, I simply run `drush site-install`, with the `--existing-config` option:
```
$ terminus drush newsite.dev -- site-install --verbose --existing-config
```
Reminder: By config, I mean Drupal configuration entities ([Configuration Management documentation](https://www.drupal.org/docs/configuration-management)).
* Optionally, add `--yes` and the script will assume "yes" to all prompts.
* Long ago, we used to use the config_installer module to install Drupal using
config files in a project codebase.
* Reminder: The new site won’t have content, because I didn't copy the demo site database, just the code repo.
