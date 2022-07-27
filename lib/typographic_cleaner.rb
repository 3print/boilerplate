# encoding: utf-8

module TypographicCleaner
  class Rule
    def initialize(expression, replacement, debug=false)
      @expression = expression
      @replacement = replacement
      @debug = debug
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
    def initialize(expression, debug=false)
      @expression = expression
      @debug = debug
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
        match = re.match(string, match.end(0))
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

    def configure(locale=:en)
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

    def ignore(expr, debug=false)
      @ignores ||= {}
      @ignores[@locale] ||= []
      @ignores[@locale] << Ignore.new(expr, debug)
    end

    def rule (expr, repl=nil, debug=false, &block)
      @rules ||= {}
      @rules[@locale] ||= {}

      @group ||= :__global__
      @rules[@locale][@group] ||= []

      if block_given?
        @rules[@locale][@group] << Rule.new(expr, block, debug)
      else
        @rules[@locale][@group] << Rule.new(expr, repl, debug)
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
