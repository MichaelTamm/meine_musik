# Meine Musik Android app

_Table of contents:_

<!-- toc -->

- [Release on Google Play](#release-on-google-play)

<!-- tocstop -->

## Release on Google Play

1. Build and upload a new version of the app to the Google Play Console using fastlane:
```bash
cd android
gem install bundler # optional if bundler is not already installed
bundle update --all # optional to update all gems to the latest version
bundle exec fastlane deploy
```
2. Prepare a new release in the Google Play Console, and submit it for review.
Start at https://play.google.com/console/u/0/developers/8809094835044872950/app/4972821853502283296/app-dashboard 
