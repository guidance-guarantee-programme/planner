require 'rails_helper'

RSpec.describe Appointment do
  subject { build_stubbed(:appointment) }

  it 'defaults #status to `pending`' do
    expect(described_class.new).to be_pending
  end

  it 'delegates `#reference` to the `booking_request`' do
    expect(subject.reference).to eq(subject.booking_request.reference)
  end

  it 'audits changes upon update' do
    original = create(:appointment)

    original.update(
      name: 'Dave',
      email: 'dave@example.com',
      phone: '0208 252 4729',
      proceeded_at: '2016-06-21 14:15',
      guider_id: '3'
    )

    expect(original.audits).to be_present
  end

  describe 'validation' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    %i(name email phone guider_id location_id proceeded_at).each do |attribute|
      it "requires the #{attribute}" do
        subject[attribute] = ''

        expect(subject).to be_invalid
      end
    end
  end
end
