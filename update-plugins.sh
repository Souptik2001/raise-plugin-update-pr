#! /bin/bash

if [[ -z "$1" || -z "$2" ]]
then
      echo "USAGE: ./update-plugins.sh <prefix> <base_branch>"
	  exit 1
fi

prefix=$1 &&\
baseBranch=$2 &&\

pluginsToBeUpdatedRaw=$( $prefix wp plugin update --all --dry-run --format=json )

echo $pluginsToBeUpdatedRaw | jq -c '.[]' | while read object; do

    pluginToBeUpdated=$( jq -r '.name' <<< $object ) &&\
	lowerVersion=$( jq -r '.version' <<< $object ) &&\
	upperVersion=$( jq -r '.update_version' <<< $object ) &&\

	echo "Updating $pluginToBeUpdated plugin from version $lowerVersion to $upperVersion" &&\

	git checkout $baseBranch &&\

	git checkout -b "update-plugin/$baseBranch-$pluginToBeUpdated-$lowerVersion-$upperVersion" &&\

	## Not using WP-CLI because it is causing the loop to end, and couldn't find any reason for that.
	# $prefix wp plugin update $pluginToBeUpdated --version=$upperVersion

	rm -r plugins/$pluginToBeUpdated &&\

	curl https://downloads.wordpress.org/plugin/$pluginToBeUpdated.zip --output plugins/$pluginToBeUpdated.zip &&\

	unzip plugins/$pluginToBeUpdated.zip -d plugins/ &&\

	rm -r plugins/$pluginToBeUpdated.zip &&\

	git add plugins/$pluginToBeUpdated &&\

	git commit -m "chore: Update $pluginToBeUpdated plugin from version $lowerVersion to $upperVersion" &&\

	git push origin update-plugin/$baseBranch-$pluginToBeUpdated-$lowerVersion-$upperVersion &&\

	gh pr create --base $baseBranch --head update-plugin/$baseBranch-$pluginToBeUpdated-$lowerVersion-$upperVersion --title "[$baseBranch] Update $pluginToBeUpdated plugin from version $lowerVersion to $upperVersion" --body "[do-not-scan]"

done
