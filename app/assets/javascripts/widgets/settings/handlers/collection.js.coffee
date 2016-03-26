{to_array} = SettingsEditor.Utils

SettingsEditor.handlers.push
  type: 'collection'
  match: (v) ->
    (typeof v is 'string' and v.indexOf(',') >= 0) or v.type is 'collection'
  fake_value: -> ['foo','bar','baz']
  save: (hidden) ->
    hidden.value = JSON.stringify({
      type: 'collection'
      values: to_array hidden.collection_input.val()
    })

  additional_fields: (value, hidden) ->
    normalize_value = (v) -> v.values ? to_array v
    collection_update = => @save(hidden)
    additional_fields = $ """
      <label for="#{hidden.id}_collection">#{'settings_input.collection.values.label'.t()}</label>
      <input type="text"
             class="form-control"
             id="#{hidden.id}_collection"
             data-type="collection"
             placeholder="#{'settings_input.collection.values.placeholder'.t()}">
      </input>
    """

    collection_input = additional_fields.filter('input')
    hidden.collection_input = collection_input

    collection_input.on 'change', collection_update
    collection_input.val normalize_value(value) unless value is 'collection'
    additional_fields
