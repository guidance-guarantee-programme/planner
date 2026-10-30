require 'rails_helper'

RSpec.describe SummaryDocumentLink do
  let(:appointment) { build(:appointment, :with_address) }

  subject { described_class.query(appointment) }

  it 'includes the guider first name' do
    expect(subject).to include('%5Bguider_name%5D=Ben')
  end

  it 'includes the first name' do
    expect(subject).to include('%5Bfirst_name%5D=Mortimer')
  end

  it 'includes the last name' do
    expect(subject).to include('%5Blast_name%5D=Smith')
  end

  it 'includes the date of appointment' do
    expect(subject).to include('%5Bdate_of_appointment%5D=2016-06-20')
  end

  it 'includes the reference number' do
    expect(subject).to include("%5Breference_number%5D=#{appointment.reference}")
  end

  it 'includes the Welsh language flag' do
    expect(subject).to include('%5Bwelsh%5D=false')
  end

  it 'includes the telephone appointment flag' do
    expect(subject).to include('%5Btelephone_appointment%5D=false')
  end

  it 'includes encoded address elements' do
    expect(subject).to include(
      '22+Dalston+Lane',
      'Hackney',
      'London',
      'E8+3AZ',
      'United+Kingdom'
    )
  end
end
