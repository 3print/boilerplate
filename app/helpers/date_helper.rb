module DateHelper
  def format_time_range(start_date, end_date)
    if start_date.beginning_of_day == end_date.beginning_of_day
      date = start_date.beginning_of_day.l(format: :long_ordinal)
      start_time = start_date.l(format: :time)
      end_time = end_date.l(format: :time)

      'timedelta.same_day'.t(date: date, start_time: start_time, end_time: end_time)
    else
      start_time = start_date.l(format: :time)
      end_time = end_date.l(format: :time)

      'timedelta.differents_day'.t({
        start_date: start_date.l(format: :long_ordinal),
        end_date: end_date.l(format: :long_ordinal),
        start_time: start_time,
        end_time: end_time
      })
    end
  end
end
