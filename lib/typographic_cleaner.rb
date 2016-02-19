# encoding: utf-8

module TypographicCleaner
  class Rule
    def initialize(expression, replacement)
      @expression = expression
      @replacement = replacement
    end

    def source
      @expression.is_a?(Regexp) ? @expression.source.force_encoding('utf-8') : expression
    end

    def options
      flags = 0
      if @expression.is_a?(Regexp)
        flags += Regexp::IGNORECASE if (@expression.options & Regexp::IGNORECASE) > 0
        flags += Regexp::MULTILINE if (@expression.options & Regexp::MULTILINE) > 0
      else
        flags = 0
      end

      flags
    end

    def fix (string)
      regex = Regexp.new(source, options)

      if @replacement.is_a?(Proc)
        string.gsub(regex, &@replacement)
      else
        string.gsub(regex, @replacement)
      end
    end
  end

  class Ignore
    def initialize(expression)
      @expression = expression
    end

    def source
      @expression.is_a?(Regexp) ? @expression.source.force_encoding('utf-8') : expression
    end

    def options
      flags = 0
      if @expression.is_a?(Regexp)
        flags += Regexp::IGNORECASE if (@expression.options & Regexp::IGNORECASE) > 0
        flags += Regexp::MULTILINE if (@expression.options & Regexp::MULTILINE) > 0
      else
        flags = 0
      end

      flags
    end

    def ranges(string)
      re = Regexp.new(source, options)

      ranges = []
      match = re.match(string)

      while !match.nil? do
        break if !ranges.empty? && (match.begin(0) == ranges.last.first || match.end(0) == ranges.last.last)
        ranges << [match.begin(0), match.end(0)]
        match = re.match(string)
      end

      return ranges
    end
  end

  class << self
    def clean (string, options={})
      return if string.nil?

      ignored = []

      locale = (options[:locale] || I18n.locale).to_sym

      return string if @rules.nil?

      rules = @rules[locale]
      ignores = @ignores[locale] || []

      return string if rules.nil?

      ranges = compactRanges(ignores.map {|ignore| ignore.ranges(string) }.flatten(1))

      included, excluded = splitByRanges(string, ranges)

      included.each_with_index do |s,i|
        rules.each_pair do |k,g|
          g.each do |rule|
            s = rule.fix(s)
          end
        end
        included[i] = s
      end

      alternateJoin(included, excluded).html_safe
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

    def ignore(expr)
      @ignores ||= {}
      @ignores[@locale] ||= []
      @ignores[@locale] << Ignore.new(expr)
    end

    def rule (expr, repl=nil, &block)
      @rules ||= {}
      @rules[@locale] ||= {}

      @group ||= :__global__
      @rules[@locale][@group] ||= []

      if block_given?
        @rules[@locale][@group] << Rule.new(expr, block)
      else
        @rules[@locale][@group] << Rule.new(expr, repl)
      end
    end

    def rangesIntersects (rangeA, rangeB)
      startA, endA = rangeA
      startB, endB = rangeB

      return (startB >= startA && startB <= endA) ||
             (endB >= startA && endB <= endA) ||
             (startA >= startB && startA <= endB) ||
             (endA >= startB && endA <= endB)
    end

    def splitByRanges (string, ranges)
      included = []
      excluded = []

      start = 0
      ranges.each do |range|
        included << string[start...range[0]]
        excluded << string[range[0]...range[1]]
        start = range[1]
      end
      included << string[start...string.length]

      return [included, excluded]
    end

    def alternateJoin (a, b)
      string = ''

      a.each_with_index do |s, i|
        string += s
        string += b[i] if b[i]
      end

      return string
    end

    def compactRanges (ranges)
      return [] if ranges.empty?

      newRanges = ranges.reduce [] do |memo, rangeA|
        if memo.empty?
          memo << rangeA
          memo
        else
          newMemo = memo.select do |rangeB|
            if rangesIntersects(rangeA, rangeB)
              rangeA[0] = [rangeA[0], rangeB[0]].min
              rangeA[1] = [rangeA[1], rangeB[1]].max
              false
            else
              true
            end
          end

          newMemo + [rangeA]
        end
      end

      newRanges.sort {|a, b| a[0] - b[0] }
    end
  end
end

TypographicCleaner.config :fr do |cleaner|
  cleaner.ignore /!?\[/
  cleaner.ignore /\]\([^\)]+\)/
  cleaner.ignore /\]\s*\[[^\]]*\]/
  cleaner.ignore /\[[^\]]+\]:.*$/m
  cleaner.ignore /(```)(.|\n)*?\1/
  cleaner.ignore /^\x20{4}.*$/m
  cleaner.ignore /(`{1,2}).*?\1/
  cleaner.ignore /\b((?:[a-zA-Z][\w-]+:(?:\/{1,3}|[a-zA-Z0-9%])|www\d{0,3}[.]|[a-zA-Z0-9.\-]+[.][a-zA-Z]{2,4}\/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'".,<>?\u00AB\u00BB\u201C\u201D\u2018\u2019]))/

  cleaner.group :spaces do
    cleaner.rule /\x20+/, ' '
    cleaner.rule /\u00A0/, '&nbsp;'
    cleaner.rule /\b([[:alpha:]]{1,3})\s/u, '\1&nbsp;'
    cleaner.rule /([[:alnum:]]+)\s([[:alnum:]]+\.)$/mu, '\1&nbsp;\2'
  end

  cleaner.group :punctuation do
    cleaner.rule /(?:\s|&nbsp;)([!?;:])/, '&#8239;\1'
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
    cleaner.rule /\b(Lundi|Mardi|Mercredi|Jeudi|Vendredi|Samedi|Dimanche|Janvier|Février|Mars|Avril|Mai|Juin|Juillet|Aout|Septembre|Octobre|Novembre|Décembre)\b/ do |s|
      s.downcase
    end
    cleaner.rule /(\d)h(\d)/, '\1 h \2'
  end

  cleaner.group :ligatures do
    cleaner.rule /oe/, '&#339;'
    cleaner.rule /O(e|E)/, '&#338;'
  end

  cleaner.group :quotes do
    cleaner.rule /’/, '&rsquo;'

    cleaner.rule /(\w)'(\w)/, '\1&rsquo;\2'
    cleaner.rule /"\s+([^"]+)\s+"/, '&ldquo;&#8239;\1&#8239;&rdquo;'
    cleaner.rule /"([^"]+)"/, '&ldquo;&#8239;\1&#8239;&rdquo;'
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
