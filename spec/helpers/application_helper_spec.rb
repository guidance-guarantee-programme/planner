require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe '.guard_missing_location' do
    context 'when the location is missing' do
      it 'responds with a message' do
        wrapped_entity = double(location_id: 'bleh')
        allow(wrapped_entity).to receive(:whoops).and_raise(ArgumentError)

        expect(
          helper.guard_missing_location(wrapped_entity, :whoops)
        ).to eq('<span title="bleh">Missing</span>')
      end
    end
  end
end
