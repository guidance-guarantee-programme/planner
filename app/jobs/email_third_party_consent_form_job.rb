class EmailThirdPartyConsentFormJob < ActiveJob::Base
  queue_as :default

  def perform(appointment)
    return unless
      appointment.booking_request.email_consent_form_required? &&
      appointment.booking_request.email_consent?

    render_and_attach_pdf(appointment)

    Appointments.consent_form(appointment).deliver_now

    EmailThirdPartyConsentFormActivity.from!(appointment.booking_request)
  end

  private

  def render_and_attach_pdf(appointment)
    pdf = PdfRenderer.new(appointment).call

    appointment.generated_consent_form.attach(
      io: pdf,
      filename: "#{appointment.reference}.pdf",
      content_type: 'application/pdf'
    )
  end
end
