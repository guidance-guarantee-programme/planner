module UserHelpers
  def given_the_user_identifies_as_hackneys_booking_manager
    @user = create(:hackney_booking_manager)
    GDS::SSO.test_user = @user

    yield
  ensure
    GDS::SSO.test_user = nil
  end
end
