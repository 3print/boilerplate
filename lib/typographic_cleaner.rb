module TypographicCleaner
  class << self
    def clean (string, options={})
      ignored = []

      locale = (options[:locale] || I18n.locale).to_sym

      return string if @rules.nil?

      rules = @rules[locale]

      return string if rules.nil?

      if !options[:includes].nil?
        ignored = rules.keys.reject {|k|
          options[:includes].include?(k)
        }
      elsif !options[:excludes].nil?
        ignored = options[:excludes]
      end

      outputString = string
      rules.each_pair do |group, rules|
        unless ignored.include?(group)
          rules.each do |expr, repl|
            if repl.is_a?(Proc)
              outputString = outputString.gsub(expr, &repl)
            else
              outputString = outputString.gsub(expr, repl)
            end
          end
        end
      end

      outputString.html_safe
    end

    def config(locale=:en)
      @locale = locale
      yield self if block_given?
      @locale = nil
    end

    def group(name)
      previous_group = @group
      @group = name.to_sym
      yield self if block_given?
      @group = previous_group
    end

    def rule (expr, repl=nil, &block)
      @rules ||= {}
      @rules[@locale] ||= {}

      @group ||= :__global__
      @rules[@locale][@group] ||= []

      if block_given?
        @rules[@locale][@group] << [expr, block]
      else
        @rules[@locale][@group] << [expr, repl]
      end
    end
  end
end

TypographicCleaner.config :fr do |cleaner|
  cleaner.group :spaces do
    cleaner.rule /\x20+/, ' '
    cleaner.rule /\u00A0/, '&nbsp;'
  end

  cleaner.group :punctuation do
    cleaner.rule /\x20([!?;:%])/, '&nbsp;\1'
    cleaner.rule /(\d+)%(?![\d\w])/, '\1&nbsp;%'
    cleaner.rule /([!?])\1+/, '\1'
    cleaner.rule /([Ee]tc)(...|…)/, '\1.'
    cleaner.rule /\.{3,}/, '&hellip;'
    cleaner.rule /Mr\./, 'M.'
    cleaner.rule /N°/, 'N&#186;'
  end

  cleaner.group :ordinal_numbers do
    cleaner.rule /(\d{2,})[èe]mes/, '\1<sup>èmes</sup>'
    cleaner.rule /(\d{1})ers/, '\1<sup>ers</sup>'
    cleaner.rule /(\d{1})[èe]res/, '\1<sup>res</sup>'
    cleaner.rule /(\d{1})[èe]mes/, '\1<sup>es</sup>'
    cleaner.rule /(\d)[èe]re/, '\1<sup>re</sup>'
    cleaner.rule /(\d)[èe]me/, '\1<sup>e</sup>'
  end

  cleaner.group :datetime do
    cleaner.rule /(Lundi|Mardi|Mercredi|Jeudi|Vendredi|Samedi|Dimanche|Janvier|Février|Mars|Avril|Mai|Juin|Juillet|Aout|Septembre|Octobre|Novembre|Décembre)/ do |s|
      s.downcase
    end
    cleaner.rule /(\d)h(\d)/, '\1 h \2'
  end

  cleaner.group :ligatures do
    cleaner.rule /oe/, '&#339;'
    cleaner.rule /Oe/, '&#338;'
  end

  cleaner.group :quotes do
    cleaner.rule /’/, '&rsquo;'

    cleaner.rule /^(.*\w)'(\w)/  do |s|
      if (/!\[[^\]]+\]\([^"]+"/ =~ s).present?
        s
      else
        s.gsub(/^(.*\w)'(\w)/, '\1&rsquo;\2')
      end
    end

    cleaner.rule /^([^"]*)"([^"]+)"/ do |s|
      if (/!\[[^\]]+\]\([^"]+"/ =~ s).present?
        s
      else
        s.gsub(/"\s*(([^ ]| (?!"))+)\s*"/, '&ldquo;&nbsp;\1&nbsp;&rdquo;')
      end
    end
  end

  cleaner.group :symbols do
    cleaner.rule /\(c\)|\(C\)|©/, '&copy;'
    cleaner.rule /\bTM\b|™/, '&trade;'
  end

  cleaner.group :currencies do
    cleaner.rule /(\d)\$/, '\1&nbsp;$'
    cleaner.rule /(\d)€/, '\1&nbsp;&euro;'
    cleaner.rule /(\d)£/, '\1&nbsp;&#163;'
    cleaner.rule /(\d)¥/, '\1&nbsp;&#165;'
  end
end
