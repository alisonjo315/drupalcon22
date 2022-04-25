echo "Cloning the CD demo site."
git clone ssh://blahblahblah/repository.git newsite
cd newsite
# Uncomment the following lines to specify a branch of the demo site repo to use for your new site code repo (instead of the demo site repo's default branch)
# echo Branch Name:
# read BRANCH
# git checkout $BRANCH
rm -rf .git
git init
echo Site human name:
read SITE_HUMAN_NAME
echo "Site machine name (brief, lowercase, dash-separated words):"
read SITE
export PANTHEON_SITE_NAME=$SITE
terminus site:create --org your-org-id $PANTHEON_SITE_NAME "$SITE_HUMAN_NAME" empty
export PANTHEON_SITE_GIT_URL="$(terminus connection:info $PANTHEON_SITE_NAME.dev --field=git_url)"
git remote add origin $PANTHEON_SITE_GIT_URL
terminus connection:set $PANTHEON_SITE_NAME.dev git
git add .
git commit -m "first commit"
git push origin master --force
echo "Waiting for Pantheon; then we will install your site. NOTE: If you saw \"Changes to `pantheon.yml` database version detected.\" when git push ran, the \"site-install\" command that comes next may fail, because the database needs to upgrade to 10.4, and that can take several minutes. If that happens, check Pantheon dashboard \"Workflow\" to see this process finish, and re-run the site-install command."
sleep 90
terminus drush $PANTHEON_SITE_NAME.dev -- site-install --verbose --existing-config --yes
terminus drush $PANTHEON_SITE_NAME.dev -- uli --uri=dev-$PANTHEON_SITE_NAME.pantheonsite.io
