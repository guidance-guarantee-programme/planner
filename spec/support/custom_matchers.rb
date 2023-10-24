# rubocop:disable Style/CaseEquality
RSpec::Matchers.define :be_open do
  match do |actual|
    /\Aopen/i === actual[:title]
  end

  failure_message do |actual|
    "expected '#{actual[:title]}' to be 'Open'"
  end
end

RSpec::Matchers.define :be_closed do
  match do |actual|
    /\Aclosed/i === actual[:title]
  end

  failure_message do |actual|
    "expected '#{actual[:title]}' to be 'Closed'"
  end
end

RSpec::Matchers.define :have_value do |value|
  match { |node| node.value == value }

  failure_message do |actual|
    "Expected the field '#{actual[:name]}' to have value '#{value}', but it was '#{actual[:value]}' instead"
  end

  failure_message_when_negated do |actual|
    "Expected the field '#{actual[:name]}' not to have value '#{value}', but it did"
  end
end
# rubocop:enable Style/CaseEquality
