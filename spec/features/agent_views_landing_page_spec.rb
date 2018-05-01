require 'rails_helper'

RSpec.feature 'Agent views the landing page' do
  scenario 'The agent is displayed a notice' do
    given_the_user_identifies_as_an_agent do
      when_they_visit_the_application
      then_they_are_displayed_a_notice
    end
  end

  def when_they_visit_the_application
    visit '/'
  end

  def then_they_are_displayed_a_notice
    expect(page).to have_text('Place a booking request')
  end
end
