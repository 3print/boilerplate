Boilerplate
================

# Main Purpose

This project serves a base for our various projects. Its main goal is to gather the helpers we use on almost every new site.

# Setup

* clone the project

  ```bash
    git clone https://github.com/3print/boilerplate
    cd boilerplate
  ```
* create a new project from the boilerplate

  ```bash
    rake clone[my-new-project]
  ```
* Be sure to visit the Admin section ( `/admin` ), default credentials are: admin@boilerplate.com / adminboilerplate

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

## Debug

The gem 'tprint-debug' is loaded by default in the Gemfile. You can use it to output logs

```ruby
  TPrint.debug my_object # will only show if TPrint.log_level >= 2
  TPrint.log my_object
```

The `tprint-debug` output includes the location from where it's been called, so it's easier to clean up your code once you're done with the debugging.

## More Documentation

Advanced documentation can be found in the [`docs` directory](./docs)
