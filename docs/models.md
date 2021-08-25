## Models

### Policies

You can tell your model to use a shared Pundit policy, instead of having to define one for each new model. This is done as follows:

```ruby
class MyModel < ActiveRecord::Base
  set_shared_policy PublicModelPolicy
end
```

This will create a policy class for that model that extends the provided policy.

### Uploaders

By default 3 uploaders are defined for you to use:

* [AvatarUploader](../app/uploaders/avatar_uploader.rb)
* [ImageUploader](../app/uploaders/image_uploader.rb)
* [PdfUploader](../app/uploaders/pdf_uploader.rb)

### Image Regions & Gravity

When a model has images fields it's often required to also store additional informations about how to resize these images.

There's actually two ways of doing so, either using regions or gravity.

#### Regions Extensions

Regions will allow to crop images using data provided by the user when it upload an image.
In order to work the model must define a `<image_column_name>_regions` json column to store these data, and then it must call the `expose_versions_for` method (provided by the `ImageVersions` concerns) for that attribute:

```ruby
expose_versions_for :avatar, {
  thumb: [60, 60],
  profile: [128, 128],
  medium: [300, 300],
}
```

This will tell the `file_input` to render additional fields for each defined version, allowing the javacript part to create previews and editors for each of these versions.
Then, on submission of an edit form, these values will be stored in the model and used in the uploader (given it includes the `CropFromRegions` module and define a `process :version` operation in the corresponding version).

#### Image Gravity

Compared to regions, using gravity is much lighter yet less flexible solution.
In order to work the model must define a `<image_column_name>_gravity` integer column to store the gravity choice for this field and then must call the `gravity_enum` method (provided by the `ImageGravity` concern) for that attribute:

```ruby
gravity_enum :image
```

This will tell the `file_input` to append a `select` to the form allowing the user to pick one of the possible gravity options.

The uploader for that field mush then include the `ResizeWithGravity` module and add a `resize_to_fill` operation in the corresponding version.

### Images Alternative Texts

In some case, one may want to store the alt text to use for an image. In that case, just define a `<image_column_name>_alt_text` string column on the model and the `file_input` will automatically append a section for that field when rendering the file input.

### Toggle Attributes

Just like with controllers, there's a module to help creating toggeable attributes that use a datetime column rather than a boolean.

In order to define a toggeable attribute the `attr_toggle` method must be called in the model definition:

```ruby
attr_toggle :read
```

This will create a toggeable attribute for the `read_at` column of the model.
In that context the following method will be created on the model:
- `read`: Sets the current time into the `read_at` column.
- `unread`: Unsets the current time from the `read_at` column.
- `read?`: Returns a boolean of whether the `read_at` field is set or not.

It will also defines the corresponding scopes on the model:
- `read`: Filters records that have a value in the `read_at` column.
- `unread`: Filters records that doesn't have a value in the `read_at` column.

The prefix to use to generate the toggling off method can be specified using an `:off` option passed to the helper. In case the off method doesn't use the save verb (such as in `accept` and `reject`) the `off` option will allow you to set the name of the togging off action independently of the base action.

Scopes are defined using the past tense of the provided verbs (with the latter example it'll give `accepted` and `rejected` respectively).

### Dashboard Extensions

This module provides a `add_to_dashboard` method that you can use to make the model appear on the admin dashboard automatically.

```ruby
add_to_dashboard size: 1, weight: 2, columns: [
  :user_card,
  actions: [
    :edit,
    destroy: {method: :delete}
  ]
]
```

The possible parameters are:
- `size`: Either `1` or `2`, it will either use a half column or a full column.
- `weight`: Used to organize models in the dashboard, the higher the `weight` the further in the page the model will appear.
- `columns`: Allows to define which columns to display in the table.
- `scope`: Just like with the controller `scope_resource` method you can define how to filter records to show in the table.
- `order`: How to sort records in the table.
- `limit`: How many records to show in the table.
- `if`: A proc to test whether or not show the table for that model.
- `unless`: A proc to test whether or not show the table for that model.
- `title`: The title to use for the dashboard's card.
- `create_action`: A boolean to define whether to show a create action button or not. Defaults to `true`.

### Displayable module

This module provides a few methods to help with showing/editing data from models in the default views. Mostly it'll help make a binding between a column and a way to render it.
For instance using:

```ruby
column_display_type :attr, :date
```

Will make the `attr` column being displayed using the date template in the default show view, and also the `inputs_for` helper will use a date input for that field.
