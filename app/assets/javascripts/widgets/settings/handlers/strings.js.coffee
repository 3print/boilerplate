{no_empty_string} = SettingsEditor.Utils

SettingsEditor.handlers.push
  type: 'string'
  match: (v) -> v is 'string' or v.type is 'string'
  fake_value: -> 'preview string'
  save: (hidden) ->
    textarea = hidden.textarea[0].checked
    limit = no_empty_string hidden.limit.val()

    if textarea or limit?
      data = type: 'string'
      data.textarea = true if textarea
      data.limit = limit if limit?
      data = JSON.stringify(data)
    else
      data = 'string'

    hidden.value = data

  additional_fields: (value, hidden) ->
    update = => @save(hidden)
    html = """
    <div class="row">
      <div class="col-sm-6">
        <input
          type="checkbox"
          class="form-control"
          id="#{hidden.id}_textarea"
          data-name="textarea">
        </input>
        <label for="#{hidden.id}_textarea">#{"settings_input.string.textarea.label".t()}</label>
      </div>
      <div class="col-sm-6">
        <label for="#{hidden.id}_limit">#{"settings_input.string.limit.label".t()}</label>
        <input
          type="number"
          class="form-control"
          step="1"
          id="#{hidden.id}_limit"
          placeholder="#{"settings_input.string.limit.placeholder".t()}"
          data-name="limit">
        </input>
      </div>
    </div>
    """

    additional_fields = $(html)

    hidden.textarea = additional_fields.find('[data-name="textarea"]')
    hidden.limit = additional_fields.find('[data-name="limit"]')

    hidden.textarea.on 'change', update
    hidden.limit.on 'change', update

    hidden.limit.val value.limit if value.limit?
    hidden.textarea.checked = true if value.textarea

    additional_fields

SettingsEditor.handlers.push
  type: 'markdown'
  save: (hidden) -> hidden.value = 'markdown'
  match: (v) -> v is 'markdown' or v.type is 'markdown'
  fake_value: -> 'preview string'
