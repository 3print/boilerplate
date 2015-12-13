## Models

### Uploaders

By default 3 uploaders are defined for you to use:

* [AvatarUploader](../app/uploaders/avatar_uploader.rb)
* [ImageUploader](../app/uploaders/image_uploader.rb)
* [PdfUploader](../app/uploaders/pdf_uploader.rb)

### Policies

You can tell your model to use a shared Pundit policy, instead of having to define one for each new model. This is done as follows:

```ruby
class MyModel < ActiveRecord::Base
  set_shared_policy PublicModelPolicy
end
```

###
