
RSpec::Matchers.define :be_same_day do |date|
  match do |actual|
    actual.to_date == date.to_date
  end

  failure_message_for_should do |actual|
    "expected #{actual.l} to #{description}"
  end

  failure_message_for_should_not do |actual|
    "expected #{actual.l} not to #{description}"
  end

  description do
    "be same day as #{date.to_date.l}"
  end
end
