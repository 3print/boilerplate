## Forms

When accessing the `new` or `edit` views for a model the default partials will generates a form automatically for the model. This form is generated using the `inputs_for` helper.

The basic usage of this helper is as demonstrated below:

```ruby
= simple_nested_form_for resource, url: resource_path do |form_builder|
  = inputs_for resource, form_builder
  = default_actions
```

This helper will use the columns returned by the `default_columns_for_object` method and creates an input for each.
