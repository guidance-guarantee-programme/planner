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
