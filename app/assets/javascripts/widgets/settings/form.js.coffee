{is_json} = SettingsEditor.Utils

next_id = 0

get_next_id = -> next_id++

flat_reducer = (acc, v) -> acc.concat if Array.isArray(v) then flatten(v) else v

flatten = (a) -> a.reduce(flat_reducer, [])

split = (s) -> flatten(s.split('{{').map((s) -> s.split('}}')))

map_parts = (s) ->
  if m = /^\s*=/.exec(s)
    s.slice(m[0].length)
  else
    "'#{s.replace(/'/g, "\\'")}'"

expr_reducer = (acc, s) ->
  if acc.length > 0 and acc[acc.length - 1].match(/(\?|:)\s*$/)
    acc[acc.length - 1] += s
  else if s.match(/^\s*(:|\))\s*$/)
    acc[acc.length - 1] += s
  else unless s.match(/^\s*'|\?\s*$/)
    acc.push "(#{s})"
  else
    acc.push(s)

  acc

sanitize = (str) ->
  str
  .replace(/\s+/g, ' ')
  .replace(/&gt;/g, '>')
  .replace(/&lt;/g, '<')
  .replace(/&amp;/g, '&')

convert = (str) ->
  split(sanitize(str)).map(map_parts).reduce(expr_reducer, []).join(' + ')

class window.SettingsForm
  @tpl: (str, data) ->
    @tpl_cache ?= {}
    # Figure out if we're getting a template, or if we need to
    # load the template - and be sure to cache the result.
    fn = if /^[-_a-zA-Z]+$/.test(str)
      @tpl_cache[str] ?= @tpl(document.getElementById(str).innerHTML)
    else
      try
        body = "with(obj){ return #{convert(str)} }"
        new Function('obj', body)
      catch e
        console.error str
        console.error body
        throw e
    # Provide some basic currying to the user
    if data then fn(data) else fn

  constructor: (@source) ->
    @settings = @source.data('settings')
    @values = @source.data('values') ? {}
    @id = @source.data('id') ? get_next_id()

  render: ->
    html = ''

    for setting, type of @settings
      html += "<div class='field'>"

      label = "settings_form.#{setting}".t()
      id = "#{setting}-#{@id}"
      setting_parameters = {}

      type = JSON.parse(type) if typeof type is 'string' and is_json(type)

      if type? and typeof type is 'object'
        setting_parameters = type
        {type} = type

      html += @get_field(type, {
        id
        label
        setting
        setting_parameters
        value: @values[setting]
      })

      html += '</div>'

    html

  get_field: (type, options) ->
    tpl = JST["templates/settings/#{type}"] ? @constructor.tpl(type)
    tpl(options)
