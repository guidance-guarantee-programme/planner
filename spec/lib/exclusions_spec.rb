require 'rails_helper'

RSpec.describe Exclusions do
  subject { described_class.new(location_id) }

  context 'when CAS' do
    let(:location_id) { CAS_LOCATION_IDS.first }

    it 'excludes the correct dates' do
      expect(subject.include?('2019-04-19'.to_date)).to be_falsey

      expect(subject.include?('2019-12-25'.to_date)).to be_truthy
    end
  end

  context 'when non-CAS' do
    let(:location_id) { 'bleh-bleh' }

    it 'excludes the correct dates' do
      Exclusions::ALL_HOLIDAYS.each do |holiday|
        expect(subject.include?(holiday)).to be_truthy
      end
    end
  end
end
