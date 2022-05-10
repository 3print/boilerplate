## Assets

#### Stylesheets

Stylesheets are still compiled through Sprockets, nothing different from older rals versions. I should just work as long as you use `stylesheet_link_tag` to link your stylesheets.

#### Javascripts

The javascript stack now uses [jsbundling-rails](https://github.com/rails/jsbundling-rails) in place of rails' webpacker (which has been discontinued).

The main differences with the previous webpacker setup are:
- Importing from the `vendor` directory is no longer automated, you'll have to specify the full relative path in order to properly import files from there.
- Working locally and compiling files was previously achieved using `./bin/webpack-dev-server`, it's now replaced by `yarn build --watch` and will no longer automatically reload pages in the browser.
