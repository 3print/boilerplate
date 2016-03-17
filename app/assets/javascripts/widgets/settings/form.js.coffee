{is_json} = SettingsEditor.Utils

class window.SettingsForm
  @tpl: (str, data) ->
    @tplCache ?= {}
    # Figure out if we're getting a template, or if we need to
    # load the template - and be sure to cache the result.
    fn = if !/\W/.test(str)
      @tplCache[str] ?= @tpl(document.getElementById(str).innerHTML)
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

  constructor: (@settings, @values={}) ->

  render: ->
    html = ''

    for setting, type of @settings
      html += "<div class='field'>"

      label = "blocks.settings.#{setting}".t()
      id = "#{setting}-#{@id}"
      settingParameters = {}

      type = JSON.parse(type) if is_json type

      if type? and typeof type is 'object'
        settingParameters = type
        {type} = type

      html += @getField(type, {
        id
        label
        setting
        settingParameters
        value: @values[setting]
      })

      html += '</div>'

    html

  getField: (type, options) -> @constructor.tpl(type, options)
