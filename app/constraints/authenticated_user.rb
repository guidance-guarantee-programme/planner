class AuthenticatedUser
  def matches?(request)
    warden = request.tnv['warden']
    warden&.authenticated? && !warden.user.remotely_signed_out?
  end
end
