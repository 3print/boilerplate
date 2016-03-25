{is_json} = SettingsEditor.Utils

next_id = 0

get_next_id = -> next_id++

class window.SettingsForm
  @tpl: (str, data) ->
    @tpl_cache ?= {}
    # Figure out if we're getting a template, or if we need to
    # load the template - and be sure to cache the result.
    fn = if !/\W/.test(str)
      @tpl_cache[str] ?= @tpl(document.getElementById(str).innerHTML)
    else
      try
        new Function(
          'obj',
          """
            var p=[]
            var print = function(){
              p.push.apply(p,arguments)
            }
            with(obj){
              p.push(\'#{
                str.replace(/[\r\t\n]/g, ' ')
                .split('{{')
                .join('\t')
                .replace(/((^|\}\})[^\t]*)'/g, '$1\n')
                .replace(/\t=(.*?)\}\}/g, '\',$1,\'')
                .split('\t')
                .join('\');')
                .split('}}')
                .join('p.push(\'')
                .split('\n')
                .join('\\\'')
              }\')
            }
            return p.join(\'\')
          """
        )
      catch e
        console.error str
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

      label = "blocks.settings.#{setting}".t()
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

  get_field: (type, options) -> @constructor.tpl(type, options)
