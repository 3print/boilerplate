module TypographicHelper
  def clean(str)
    TypographicCleaner.clean(str)
  end
end

TypographicCleaner.configure :fr do |cleaner|
  # A bunch or rules to ignore markdown specific elements:

  # Ignore [ or ![ of links and images
  cleaner.ignore /!?\[/
  # Ignore ](...) of links and images
  cleaner.ignore /\]\([^\)]+\)/
  # Ignore ][...] of referenced links
  cleaner.ignore /\]\s*\[[^\]]*\]/
  # Ignore [...] of referenced links definition
  cleaner.ignore /\[[^\]]+\]:.*$/m
  # Ignore code blocks
  cleaner.ignore /(```)(.|\n)*?\1/ # syntax coloring patch: ```
  # Ignore four spaces defined code blocks
  cleaner.ignore /^\x20{4}.*$/m
  # Ignore content of inlined code
  cleaner.ignore /(`{1,2}).*?\1/ # syntax coloring patch: `
  # Ignore plain urls in text
  cleaner.ignore /\b((?:[a-zA-Z][\w-]+:(?:\/{1,3}|[a-zA-Z0-9%])|www\d{0,3}[.]|[a-zA-Z0-9.\-]+[.][a-zA-Z]{2,4}\/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'".,<>?\u00AB\u00BB\u201C\u201D\u2018\u2019]))/
  # Ignore html entities
  cleaner.ignore /&[^;]+;/
  # Ignore html node
  cleaner.ignore /<[^>]+>/

  cleaner.group :spaces do
    # Replace multiple spaces with a single one
    cleaner.rule /\x20+/, ' '
    # Replaces unicode non-breaking space with html entity
    cleaner.rule /\u00A0/, '&nbsp;'
    # Put non-breaking space after a word shorter than 4 characters
    cleaner.rule /\b([[:alpha:]]{1,3})\s/u, '\1&nbsp;'
    # Use non-breaking space between words before a period.
    # Avoids having a orphan words at the end of a paragraph.
    cleaner.rule /([[:alnum:]]+)\s([[:alnum:]]+\.)$/mu, '\1&nbsp;\2'
  end

  cleaner.group :punctuation do
    # Use non-breaking spaces before !, ? and :
    cleaner.rule /(?<!\s)([!?:])/, '&#8239;\1'
    cleaner.rule /(?:\s|&nbsp;)([!?:])/, '&#8239;\1'
    # Percentages should have a non-breaking space between value and symbol
    cleaner.rule /(\d+)%(?![\d\w])/, '\1&nbsp;%'
    # Replace repeated ! or ? with a single instance
    cleaner.rule /([!?])\1+/, '\1' # syntax coloring patch: /
    # etc. and not etc...
    cleaner.rule /([Ee]tc)(...|…)/, '\1.'
    # … and not ...
    cleaner.rule /\.{3,}/, '&hellip;'
    # Mr. is an outdated form, M. is now preferred
    cleaner.rule /Mr\./, 'M.'
    # The ° on a keyboard is for degree and not a numero sign
    cleaner.rule /[Nn]°/, '&#8470;'
    # Replace - in composed words with non-breaking version
    cleaner.rule /(\w)-(\w)/, '\1&#8209;\2'
    # Replace between words with dash
    cleaner.rule /(\w)\s+-\s+(\w)/, '\1 &#8212; \2'
  end

  cleaner.group :ordinal_numbers do
    # Put ordinal suffixes in a <sup> tag and addresses common mistakes:
    # 1ere correct form is 1re
    # 3eme correct form is 3e
    # 1eres correct form is 1res
    # 3emes correct form is 3es
    cleaner.rule /(\d{2,})[èe]mes/, '\1<sup>èmes</sup>' # syntax coloring patch: '
    cleaner.rule /(\d{1})ers/, '\1<sup>ers</sup>' # syntax coloring patch: '
    cleaner.rule /(\d{1})[èe]res/, '\1<sup>res</sup>' # syntax coloring patch: '
    cleaner.rule /(\d{1})[èe]mes/, '\1<sup>es</sup>' # syntax coloring patch: '
    cleaner.rule /(\d)[èe]re/, '\1<sup>re</sup>' # syntax coloring patch: '
    cleaner.rule /(\d)[èe]me/, '\1<sup>e</sup>' # syntax coloring patch: '
  end

  cleaner.group :datetime do
    # Days and months names should not be capitalized
    cleaner.rule /\b(Lundi|Mardi|Mercredi|Jeudi|Vendredi|Samedi|Dimanche|Janvier|Février|Mars|Avril|Mai|Juin|Juillet|Aout|Septembre|Octobre|Novembre|Décembre)\b/ do |s|
      s.downcase
    end
    # The h in an numeric hour should be spaced
    cleaner.rule /(\d)h(\d)/, '\1&nbsp;h&nbsp;\2'
  end

  # Replaces common ligatures
  cleaner.group :ligatures do
    cleaner.rule /oe/, '&#339;'
    cleaner.rule /O(e|E)/, '&#338;'
  end

  cleaner.group :quotes do
    # replace typographic quotes with html entity
    cleaner.rule /’/, '&rsquo;'
    # replace single quotes with typographic ones
    cleaner.rule /(\w)'(\w)/, '\1&rsquo;\2' # syntax coloring patch: '
    # replace double quotes with typographic ones plus proper spacing
    cleaner.rule /"([^"]+)"/, '&#171;&#8239;\1&#8239;&#187;' # syntax coloring patch: "
    cleaner.rule /"\s+([^"]+)\s+"/, '&#171;&#8239;\1&#8239;&#187;' # syntax coloring patch: "
  end

  # Replace some basic symbols with html entities
  cleaner.group :symbols do
    cleaner.rule /\(c\)|\(C\)|©/, '&copy;'
    cleaner.rule /\bTM\b|™/, '&trade;'
  end

  # In french currencies are placed last and has a non-breaking space before
  cleaner.group :currencies do
    cleaner.rule /(\d)\$/, '$&nbsp;\1'
    cleaner.rule /(\d)€/, '\1&nbsp;&euro;'
    cleaner.rule /(\d)£/, '\1&nbsp;&#163;'
    cleaner.rule /(\d)¥/, '\1&nbsp;&#165;'
  end
end
