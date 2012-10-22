Amoe.ba Company Site
================================

This is the source to our company site at http://amoe.ba

Editing the code
-------------------------

In order to edit the code, you must install MiddleMan:

```
gem install bundler
bundle install
```

Then while you're editing, run `bundle exec middleman server` and connect to http://localhost:4567 to see your changes.

When you want to build the site to upload, run `bundle exec middleman build` and it will create a `build/` directory, which can be uploaded.
