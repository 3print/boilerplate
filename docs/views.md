## Views

### Default Views And Overrides

All views needed for basic CRUD are covered and can be found in [`app/views/application`](../app/views/application).

Each view is built from several partials, that can be overridden individually in the corresponding `views` subfolder (see examples in [`app/views/admin/users`](../app/views/admin/users)).

The general principle that structures the partials is as follow:

Each CRUD view renders two sub-partials, one for the header and one for the content, respectively named `<action>_header` and `<action>`.
In that regard, the `index` action represent an exception as it will render two more partials before and after the whole page's content. For instance, we can wrap the models list into a form and use drag-and-drop on the list items to set a `sequence` attribute on each model using `_index_(before|after)_content` partials.

The header partial will then creates the page title, the pills and breadcrumb for the current resource (an instance or a collection). Extra pills can be defined for the `index`, `show` and `edit` actions, before or after the default ones, using the `_collection_header_(before|after)_pills` and `_instances_header_(before|after)_pills` partials. The `show` and `edit` views  share the same pills. The `new` view is the exception here and doesn't provides any pills at all as the model doesn't exist yet.

The content partial will then create the actual content of the page as follow:

- In the `index` view, a list of the models in `resource` is created as a table with the id of the resource, a link to the resource `show` page with the model's caption as text content and a button group with actions for each model. The list itself is rendered using several partials that the same kind of before/after sub-partials (more on that below). The list is wrapped into a panel and you can use the `_index_(before|after)_collection` partials to add content around the table.
- The `new` and `edit` view will render the default form for the model (see the [Forms documentation](./forms.md) for details about the default form generation).
- In the `show` view, a list of the model's attributes is created using the `default_columns_for_object` and `show_field` helpers (more on that below). It's content can be extended using the `_show_(before|after)_fields` and `_show_extra_fields` partials.

### Helpers

#### Collections

The content of the index page content is created using the `collection` helper. This helper will generate a HTML table using various partials that can be overridden on a per-model basis.

The `collection` helper is called with the collection to render and an option Hash. It automatically handles pagination of the collection so you don't need to take care of it in the controller.

##### Options

- `page_param`: By default the pagination will uses the `:page` parameter from the `params` object. This option allow you to change that behavior to use a different parameter.
- `collection_class`: By default the helper will use the collection's `klass` property to retrieve the class of the elements in the collection. This class is used to find the partials to use to render the list or the messages to use when there's no element in the collection. You can use this setting to override that behavior.
- `partial`: By default, the helper uses the `_list` partial to render the list, but you can change that by setting this option.

##### Partials

The `_list` partial in itself only wraps the collection in a table and invokes the `_list_header` and then render the `_list_row` partial for each element in the collection.

The list header will then render the table header row. By default, the helper creates a column for the id, the caption and the actions for the current model.
Extra columns can be added using the `_list_header_(before|after)_name` partials.

The list rows partial will render the same columns as the header, and uses the same system to set the extra column, using the `_list_row_(before|after)_name` partials.

The caption for each model can be extended using the `_list_item_(before|after)_details` partials.

The actions for each model are rendered by the `_list_item_actions` partial that also can be extended using the `_list_item_(before|after)_actions` partials.

#### Model Fields

When rendering the view for a model the partial will use the `default_columns_for_object` function to define which field display in the list. This method will take every column and association of the model minus the ones listed in `SKIPPED_COLUMNS` array defined in the `ModelHelper` file.

Then, for each columns the partial will call the `show_field` helper. This helper will try to render a model's field using the following strategy:

1. If the `:as` option was set when calling the `show_field` method, the type specified in the option will be used to find a partial named `_show_<type>_field`.
2. If a partial exist with a name such as `_show_<model_name>_<column>` it will be used to render the field.
3. If the column has a display type specified using the `column_display_type` method, a partial named `_show_<type>_field` will be used to render this field.
4. If the field is bound to an ActiveRecord column, the method will retrieve its type and use the `_show_<type>_field` partial to render the field
5. If no type information exists for the field or if a partial cannot be found in the steps above and the field's value is an ActiveRecord model the `show_active_record_field` partial will be used
6. If all the steps above failed, the `show_default_field` partial will be used.

#### Pills

You can use the `pill` helper (syntax similar to `link_to`) to add actions to the action bar present below the page title. Pills can be displayed with the corresponding `pills`
helper. Once pills have been displayed, they are removed from the pills pool, and won't be displayed by subsequent calls to `pills`.

You can also use the `toggle_pill` helper, which will create pills used to toggle a given attribute on a model. This is intended to be used with the `attr_toggle` and `toggle_action` in the Model and the Controller. This helper is akin to the `toggle_actions` helper which generates simple buttons with the same purpose.

See [`app/views/admin/bp_tests/_instances_header_pills_before.html.haml`](../app/views/admin/bp_tests/_instances_header_pills_before.html.haml) and [`app/views/admin/bp_tests/_list_item_actions_after.html.haml`](../app/views/admin/bp_tests/_list_item_actions_after.html.haml) for concrete examples of pills usage.

#### Breadcrumb

You can use the `breadcrumb` helper to add entries to the breadcrumb bar below the page title. The breadcrumb can be displayed with the corresponding `breadcrumbs` helper. Once breadcrumb entries have been displayed, they are removed from the breadcrumbs pool, and won't be displayed by subsequent calls to `breadcrumbs`.

The `breadcrumb` helper will produce two types of entries depending on the amount of arguments provided:

- If only one argument is passed, the resulting breadcrumb entry won't be rendered as a link, the provided argument will be used as label.
- If two arguments are passed, the resulting breadcrumb entry will be rendered as a link. The first argument will be used as label and the second will be used to create the link's url. It can be a string or an array as supported by the `polymorphic_url` helper from Rails.
