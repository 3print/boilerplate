{
  es: {
    date: {
      formats: {
        long_ordinal: lambda { |time, opts|
          "#{time.day == 1 ? "1o" : time.day} #{time.l(format: :month)}"}
      }
    },
    time: {
      formats: {
        long_ordinal: lambda { |time, opts| "#{time.day == 1 ? "1o" : time.day} #{time.l(format: :month)}" }
      }
    }
  }
}
