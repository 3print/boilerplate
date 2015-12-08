Boilerplate
================

#Main Purpose
This project serves a base for our various projects. Its main goal is to gather the helpers we use on almost every new site.

#Setup
* clone the project
  ```bash
    git clone https://github.com/3print/boilerplate
    cd boilerplate
  ```
* create a new project from the boilerplate

  ```bash
    rake clone[my-new-project]
  ```
* Enjoy!

For proper use, you'll need a AWS S3 bucket to work with. Create your bucket as usual, and then don't forget to add a complaining CORS configuration, for instance:

```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <CORSConfiguration xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
    <CORSRule>
        <AllowedOrigin>*</AllowedOrigin>
        <AllowedMethod>GET</AllowedMethod>
        <AllowedMethod>POST</AllowedMethod>
        <AllowedMethod>PUT</AllowedMethod>
        <AllowedHeader>*</AllowedHeader>
    </CORSRule>
  </CORSConfiguration>
```
#Features

## Controllers
All default actions for basic CRUD are defined in the controllers. For more info, look into [`app/controllers/concerns`](tree/master/app/controllers/concerns)
## Models
### Uploaders
By default 3 uploaders are defined for you to use:
* [AvatarUploader](tree/master/app/uploaders/avatar_uploader.rb)
* [ImageUploader](tree/master/app/uploaders/image_uploader.rb)
* [PdfUploader](tree/master/app/uploaders/pdf_uploader.rb)

### Policies
You can tell your model tu use a shared Pundit policy, instead of having to define one for each new model. This is done as follows:

```ruby
  set_shared_policy PublicModelPolicy
```

## Views
### Default views and overrides

All views needed for basic CRUD are covered and can be found in [`app/views/application`](tree/master/app/views/application)
Each view is built from several partials, that can be overridden individually in the corresponding `views` subfolder (see example in [`app/views/admin/users`](tree/master/app/views/admin/users) )

### Helpers


#### Pills
You can use the `pill` helper (syntax similar to `link_to`) to add actions to the action bar present next to the page title. Pills can be displayed with the corresponding `pills`
helper. Once pills have been displayed, there are removed from the pills pools, and won't be displayed by subsequent calls to `pills`
You can also use the `toggle_pill` and `toggle_actions` helpers, which will repectively create pills and buttons used to toggle a given attribute on a model. See [`app/views/admin/users/_instances_header_pills_extra.html.haml`](tree/master/app/views/admin/users/_instances_header_pills_extra.html.haml) and [`app/views/admin/users/_list_item_actions_after.html.haml`](tree/master/app/views/admin/users/_list_item_actions_after.html.haml) for full examples.


### Forms
### Dashboard
## Debug
The gem 'tprint-debug' is loaded by default in the Gemfile. You can use it to output logs
```ruby
  TPrint.debug my_object # will only show if TPrint.log_level >= 2
  TPrint.log my_object
```


The 'tprint-debug' output includes the location from where it's been called, so it's easier to clean up your code once you're done with the debugging.

## Tests


