require 'rails_helper'

RSpec.describe Activity do
  describe '#owner_name' do
    context 'when it has no associated user' do
      subject { build_stubbed(:activity, user: nil) }

      it 'returns a place holder' do
        expect(subject.owner_name).to eq('Someone')
      end
    end

    context 'when it has an associated user' do
      subject { build(:activity) }

      it 'returns the name of the associated user' do
        expect(subject.owner_name).to eq(subject.user.name)
      end
    end
  end
end
