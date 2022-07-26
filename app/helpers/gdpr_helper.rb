GdprConsent.configure do |config|
  config.add_script :bp_test, {                   # BOILERPLATE_ONLY
    asset: :bp_test,                              # BOILERPLATE_ONLY
    cookies: %w(bp_external),                     # BOILERPLATE_ONLY
  }                                               # BOILERPLATE_ONLY
  config.add_script :bp_test, {                   # BOILERPLATE_ONLY
    inline: 'console.log("inline js loaded");' +  # BOILERPLATE_ONLY
            'document.cookie = "bp_inline=foo";', # BOILERPLATE_ONLY
    cookies: %w(bp_inline)                        # BOILERPLATE_ONLY
  }                                               # BOILERPLATE_ONLY
end

module GdprHelper

  def has_consent_cookie?
    cookies[:cookies_consent].present?
  end

  def consent_to?(type)
    cookies[:cookies_consent].present? && JSON.parse(cookies[:cookies_consent])[type]
  end

  def render_scripts
    html = ''
    GdprConsent.get_all_scripts.each_pair do |type, scripts|
      if consent_to?(type)
        scripts.each do |script|
          if script[:inline].present?
            html << content_tag(:script, script[:inline].html_safe)
          else
            url = script[:url]
            url = path_to_javascript(script[:asset]) if url.nil? && script[:asset].present?
            html << content_tag(:script, '', src: url) if url.present?
          end
        end
      end
    end
    html.html_safe
  end

  def render_consents_config
    {
      scripts: GdprConsent.get_all_scripts,
    }.to_json
  end

  def render_scripts_config
    GdprConsent.get_all_scripts.map do |k,v|
      scripts = v.map do |script|
        if script[:inline].present?
          {inline: script[:inline], cookies: script[:cookies]}
        else
          url = script[:url]
          url = path_to_javascript(script[:asset]) if url.nil? && script[:asset].present?
          {url: url, cookies: script[:cookies]}
        end
      end
      [k, scripts]
    end.to_h.to_json.html_safe
  end

  def reject_all_payload
    {necessary: true}.update(GdprConsent.get_all_scripts.keys.map {|k| [k, false] }.to_h).to_json
  end

  def accept_all_payload
    {necessary: true}.update(GdprConsent.get_all_scripts.keys.map {|k| [k, true] }.to_h).to_json
  end
end
