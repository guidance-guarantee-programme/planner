require 'rails_helper'

RSpec.describe Exclusions do
  subject { described_class.new(location_id) }

  context 'when CAS' do
    let(:location_id) { CAS_LOCATION_IDS.first }

    it 'includes the correct dates' do
      Exclusions::CAS_HOLIDAYS.each do |holiday|
        expect(subject.include?(holiday)).to be_truthy
      end
    end
  end

  context 'when non-CAS' do
    let(:location_id) { 'bleh-bleh' }

    it 'includes the correct dates' do
      Exclusions::BANK_HOLIDAYS.each do |holiday|
        expect(subject.include?(holiday)).to be_truthy
      end
    end
  end
end
