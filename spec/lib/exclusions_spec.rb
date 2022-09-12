require 'rails_helper'

RSpec.describe Exclusions do
  it 'includes the HRH bank holiday' do
    expect(Exclusions.new.holidays).to eq(['2022-09-19'.to_date])
  end
end
