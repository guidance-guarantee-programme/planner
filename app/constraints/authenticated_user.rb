class AuthenticatedUser
  def matches?(request)
    warden = request.env['warden']

    return unless warden.authenticate?

    warden.user && !warden.user.remotely_signed_out?
  end
end
