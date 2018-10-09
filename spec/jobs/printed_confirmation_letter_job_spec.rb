require 'rails_helper'

RSpec.describe PrintedConfirmationLetterJob, '#perform' do
  let(:client) { double(Notifications::Client, send_letter: true) }

  context 'when it should not be printed' do
    it 'does not attempt to print via notify' do
      appointment = create(:appointment)

      expect(appointment).to_not be_postal_confirmation
      expect(client).to_not receive(:send_letter)

      described_class.new.perform(appointment)
    end
  end

  context 'when it should be printed' do
    it 'requests a printed confirmation via notify' do
      appointment = create(:appointment, :with_address)

      expect(client).to receive(:send_letter).with(
        template_id: PrintedConfirmationLetterJob::CONFIRMATION_TEMPLATE_ID,
        reference: appointment.reference,
        personalisation: {
          reference: appointment.reference,
          date: '20 June 2016',
          time: '2:00pm (BST)',
          location: "Hackney\nHackney Citizens Advice\n300 Mare St\nHackney\nLondon\nE8 1HE",
          guider: 'Ben',
          phone: '02086291134',
          address_line_1: 'Mortimer Smith',
          address_line_2: '22 Dalston Lane',
          address_line_3: '',
          address_line_4: '',
          address_line_5: 'Hackney',
          address_line_6: 'London',
          postcode: 'E8 3AZ'
        }
      )

      described_class.new.perform(appointment)
    end

    it 'requests a reschedule printed confirmation via notify' do
      appointment = create(:appointment, :with_address)
      appointment.update(name: 'Bob Smith')

      expect(client).to receive(:send_letter).with(
        hash_including(template_id: PrintedConfirmationLetterJob::RESCHEDULE_TEMPLATE_ID)
      )

      described_class.new.perform(appointment)
    end
  end

  before do
    ENV['NOTIFY_API_KEY'] = 'blahblah'

    allow(Notifications::Client).to receive(:new).and_return(client)
  end

  after do
    ENV.delete('NOTIFY_API_KEY')
  end
end
