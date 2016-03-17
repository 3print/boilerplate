# Public
class window.I18n
  @attachToWindow: ->
    instance = new I18n locales, $('html').attr('lang') or 'en'
    window.t = instance.getHelper()

    String::t = -> window.t(this)

  ### Public ###

  constructor: (@locales={}, @defaultLanguage='en') ->
    @languages = (k for k of @locales).sort()

  # Returns a string from the locales.
  # That function can be called either with or without a language:
  #
  # i18n.get (path.to.string')
  # i18n.get ('fr', 'path.to.string')
  #
  # If the path lead to a dead end, the function return the last element
  # in the path as a capitalized sentence.
  #
  # i18n.get (path.that.do_not_exist) # Do Not Exist
  get: (language, path, tokens={}) ->
    if !path? or typeof path is 'object'
      [language, path, tokens] = [@defaultLanguage, language, path]

    lang = @locales[language]

    throw new Error "Language #{language} not found" unless lang?
    els = path.split('.')
    (lang = lang[v]; break unless lang?) for v in els

    if typeof lang is 'object' and tokens.count?
      lang = lang[tokens.count] ? lang.other

    unless lang?
      lang = els[-1..][0].replace(/[-_]/g, ' ')
                         .replace(/(^|\s)(\w)/g, (m,sp,s) ->
                            "#{sp}#{s.toUpperCase()}")

    String(lang).replace /\#\{([^\}]+)\}/g, (token, key) ->
      return token unless tokens[key]?
      tokens[key]

  # Returns a helper function bound to the current instance that allow
  # to retrieve localized string from the `I18n` instance as well as doing
  # token substitution in the returned string.
  #
  # ```coffee
  # _ = i18n.getHelper()
  # _('path.to.string')
  # _('path.to.string_with_token', token: 'token substitute')
  # ```
  getHelper: -> (path, tokens={}) => @get(path, tokens)
