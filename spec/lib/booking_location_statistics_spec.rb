require 'rails_helper'

RSpec.describe BookingLocationStatistics, '#call' do
  let(:json) { '{}' }
  let(:statistics_serializer) { instance_double(StatisticsSerializer) }
  let(:webhook) { instance_double(StatisticsWebHook) }

  before do
    allow(statistics_serializer).to receive(:json).and_return(json)
    allow(webhook).to receive(:call).with(json).and_return(true)

    subject.call
  end

  subject { described_class.new(statistics_serializer, webhook) }

  it 'retrieves the booking location statistics JSON' do
    expect(statistics_serializer).to have_received(:json)
  end

  it 'calls the webhook with the JSON payload' do
    expect(webhook).to have_received(:call).with(json)
  end
end
