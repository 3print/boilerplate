require 'statuses'

RSpec::Matchers.define :have_role do |role|
  match do |actual|
    actual.roles.any? {|r| r.name == role.to_s }
  end

  failure_message_for_should do |actual|
    "expected user with roles #{actual.roles.map(&:name).to_sentence} to #{description}"
  end

  failure_message_for_should_not do |actual|
    "expected user with roles #{actual.roles.map(&:name).to_sentence} not to #{description}"
  end

  description do
    "have role #{role}"
  end
end
