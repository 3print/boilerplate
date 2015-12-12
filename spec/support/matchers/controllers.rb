require 'statuses'

RSpec::Matchers.define :respond_by do |expected|
  label = nil
  status = nil
  if expected.is_a? Symbol
    status = Statuses.find_status(expected)
    label = expected
  else
    status = expected
    label = Statuses.find_label(expected)
  end

  match do |actual|
    is_valid_response?(actual) &&
    actual.response_code == status
  end

  failure_message do |actual|
    if is_valid_response? actual

      "expected that #{Statuses.find_label actual.response_code} (#{actual.response_code}) would respond by #{label} (#{status}})"
    else
      "expected that #{actual} would respond by #{label} (#{status})"
    end
  end

  failure_message_when_negated do |actual|
    if is_valid_response? actual
      "expected that #{Statuses.find_label actual.response_code} (#{actual.response_code}) would not respond by #{label} (#{status}})"
    else
      "expected that #{actual} would not respond by #{label} (#{status})"
    end
  end

  description do
    "respond by #{label} (#{status})"
  end

  def is_valid_response? actual
    actual.present? &&
    actual.respond_to?(:response_code)
  end
end
