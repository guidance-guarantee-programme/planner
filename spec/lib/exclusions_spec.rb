require 'rails_helper'

RSpec.describe Exclusions do
  subject { described_class.new(location_id) }

  context 'for anything else eg CITA' do
    let(:location_id) { 'bleh' }

    it 'includes the correct dates' do
      Exclusions::CITA_HOLIDAYS.each do |holiday|
        expect(subject.include?(holiday)).to be_truthy
      end
    end
  end

  context 'when CAS' do
    let(:location_id) { create(:organisation_lookup, :cas).location_id }

    Exclusions::CAS_HOLIDAYS.each do |holiday|
      it "includes #{holiday}" do
        expect(subject.include?(holiday)).to be_truthy
      end
    end
  end

  context 'when PWNI' do
    let(:location_id) { create(:organisation_lookup, :pwni).location_id }

    Exclusions::PWNI_HOLIDAYS.each do |holiday|
      it "includes #{holiday}" do
        expect(subject.include?(holiday)).to be_truthy
      end
    end
  end
end
