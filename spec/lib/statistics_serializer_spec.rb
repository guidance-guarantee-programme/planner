require 'rails_helper'

RSpec.describe StatisticsSerializer, '#json' do
  before do
    create_list(:appointment, 2).each do |appointment|
      # force persistence for these statistics that would otherwise
      # be overwritten by the `#calculate_statistics` callback
      appointment.update_columns(fulfilment_time_seconds: 1, fulfilment_window_seconds: 10)
    end
  end

  subject { JSON.parse(described_class.new.json) }

  it 'returns fulfilment statistics as JSON' do
    expect(subject.first).to eq(
      'booking_location_id' => 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef',
      'average_fulfilment_time_seconds' => '1.0',
      'average_window_time_seconds' => '10.0'
    )
  end
end
