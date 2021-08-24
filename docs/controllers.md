## Controllers

All default actions for basic CRUD are defined in the controllers. For more info, look into [`app/controllers/concerns`](../app/controllers/concerns)

### Resource Extensions

The whole handling of controllers' default behaviours lie around the concept of resource inferred from the controller's name. For instance, given a `users_controller` the inferred resource will be the `User` model. Then depending on the current `action` the `resource` method will return either a collection or a single model.

Generally the resource is loaded in a `before_action` thanks to the `load_resource` method called in the controller definition. That resource can then be accessed either using the `resource` method, the `@resource` attribute or the `@<resource_name>` attribute (where `resource_name` is the corresponding resource name either in its singular or plural form according to the kind of action). By convention, the presence of an `id` parameter in the controller will make it search for a single model while not having that parameter will make it load a collection.

Resources can also be authorized when loading them by using `load_and_authorize_resource` instead of `load_resource`.

Both `load_resource` and `load_and_authorize_resource` can take an `options` hash that is passed to `before_action`.

##### About finding resource with a field that is not `id`

By calling the `find_by_key` method in the controller you can specify the field that will be used to query a record.

```ruby
find_by_key :permalink
```

This should be paired with having the model define a `to_param` method that returns the corresponding field instead of the `id`.

#### Scopes, Sort and Pagination

Resource collection can be automatically filtered and sorted in the loading phase using the `scope_resource` and `sort_resource` methods.

##### Scope Resource

The `scope_resource` method can be called either with a single scope name:

```ruby
scope_resource :my_scope
```

Or with a block if the scope either requires arguments or if several scopes are needed:

```ruby
scope_resource do |s|
  s.my_first_scope.my_second_scope
end
```

The `scope_resource` method can also takes an optional `options` hash to pass to the `before_action` method.

##### Sort Resource

Sorting is defined using the `sort_resource` method that only takes an `options` hash from which a `by` option will be used for the resource sorting while the other options will be passed to the `before_action`.

The value of the `by` option is any value you can pass to the `order` method of a relation.

```ruby
sort_resource by: 'name ASC'
```

##### Paginate Resource

A default pagination is generally defined at the model level through `kaminari`, but it'll only be activated in a controller by using the `paginate_resource` method. That method also allows to override the pagination using the `per` option.

```ruby
paginate_resource per: 50
```

All other options will be passed to the `before_action` method.

#### Other methods

This module also provides a few other methods to help with resource paths:

- `controller_namespace`: by default returns an empty array but should be override to specify the proper controller namespace (for instance, `[:admin]` for admin controllers). This will be prepended when building an url for a resource using the `polymorphic_url` helper.
- `resource_path_for`: takes a resource and an optional action and namespace and will return an array that can be passed in `link_to` or `polymorphic_url`.
- `route_exists_for?`: returns whether the passed-in action route exists for that controller. An optional record can be passed for member routes.

### Trafic Extensions

This is the heart of the default controllers behaviours. This module defines the CRUD methods for the resource along with the various response for each action.

### Customs Extensions

Defines some basic methods on controllers such as `not_found`, `access_denied` and so on. These methods are mostly shorthands for recurring responses from controllers.

### DateTime Extensions

With the drop of jQuery we no longer have a reliable calendar widget. Instead, and given the poor support for `datetime` inputs, we're using a combination of `date`, `time` and `hidden` input in place of using a `datetime` type. That extension makes it automatic to rebuild a date time object from the values of these three fields.

### JSON Extensions

Defines two methods `arrayify` and `rubyify` that will help casting parameters into data usable in a ruby context.

The first method mostly converts hashes where keys are numerical values into arrays.

The second method takes things a bit further and will attempt to cast parameters values into their proper ruby type.

### PDF controller

This module adds a single `pdf_controller` method that you can use to define an action on a controller that will respond with a pdf. It also helps debugging pdf generation by supporting rendering the pdf as html when the provided format is `html`.

### Toggle Extensions

This module defines the `toggle_actions` method that helps creating actions on a controller to toggle a model state.

Toggeable states on a model should be represented with a datetime field.

For instance, given a `read_at` field on a model, using `toggle_actions :read` will generates two actions on the controller, `read` and `unread` that will set and unset that field of the model when invoked.

The prefix to use to generate the toggling off action can be specified using an `:off` option passed to the helper. In case the off action doesn't use the save verb (such as in `accept` and `reject`) the `off` option will allow you to set the name of the togging off action independently of the base action.
