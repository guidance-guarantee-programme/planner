module UserHelpers
  def with_real_sso
    sso_env = ENV['GDS_SSO_MOCK_INVALID']
    ENV['GDS_SSO_MOCK_INVALID'] = '1'

    yield
  ensure
    ENV['GDS_SSO_MOCK_INVALID'] = sso_env
  end

  def given_the_user_identifies_as_an_agent_manager(&block)
    given_the_user_identifies_as(:agent_manager, &block)
  end

  def given_the_user_identifies_as_an_agent(&block)
    given_the_user_identifies_as(:agent, &block)
  end

  def given_the_user_identifies_as_hackneys_administrator(&block)
    given_the_user_identifies_as(:hackney_administrator, &block)
  end

  def given_the_user_identifies_as_ops_booking_manager(&block)
    given_the_user_identifies_as(:ops_booking_manager, &block)
  end

  def given_the_user_identifies_as_an_ops_agent_manager(&block)
    given_the_user_identifies_as(:ops_agent_manager, &block)
  end

  def given_the_user_identifies_as_hackneys_booking_manager(&block)
    given_the_user_identifies_as(:hackney_booking_manager, &block)
  end

  def given_the_user_identifies_as_cardiff_and_vales_booking_manager(&block)
    given_the_user_identifies_as(:cardiff_and_vale_booking_manager, &block)
  end

  def given_the_user_identifies_as_an_organisation_admin
    @user = create(:org_admin)
    GDS::SSO.test_user = @user

    yield
  ensure
    GDS::SSO.test_user = nil
  end

  def given_the_user_identifies_as(factory_name)
    @user = create(factory_name)
    GDS::SSO.test_user = @user

    yield
  ensure
    GDS::SSO.test_user = nil
  end
end
