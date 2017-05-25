FactoryGirl.define do
  factory :schedule do
    # Hackney
    location_id 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef'

    trait :blank do
      begin
        Schedule.slot_attributes.each do |attribute|
          add_attribute(attribute, false)
        end
      rescue ActiveRecord::StatementInvalid => e
        # this occurs during migrations since `Schedule#slot_attributes`
        # requires `Schedule` to be migrated
        Rails.logger.error(e)
      end
    end
  end
end
