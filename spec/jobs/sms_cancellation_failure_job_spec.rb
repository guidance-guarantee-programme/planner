require 'rails_helper'

RSpec.describe SmsCancellationFailureJob, '#perform' do
  let(:number) { '07715 930 455' }
  let(:client) { double(Notifications::Client, send_sms: true) }

  it 'sends an SMS' do
    expect(client).to receive(:send_sms).with(
      phone_number: '07715 930 455',
      template_id: SmsCancellationFailureJob::TEMPLATE_ID,
      reference: '07715 930 455'
    )

    described_class.new.perform(number)
  end

  before do
    ENV['NOTIFY_API_KEY'] = 'blahblah'

    allow(Notifications::Client).to receive(:new).and_return(client)
  end

  after do
    ENV.delete('NOTIFY_API_KEY')
  end
end
