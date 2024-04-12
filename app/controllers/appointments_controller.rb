# rubocop:disable Metrics/ClassLength
class AppointmentsController < ApplicationController
  before_action :populate_appointment_form, only: %i(new create)
  before_action :populate_edit_appointment_form, only: %i(edit update)

  def index
    @search = AppointmentsSearchForm.new(search_params)

    @appointments = LocationAwareEntities.new(
      @search.results,
      booking_location
    )
  end

  def edit
  end

  def update
    if @appointment_form.update(edit_appointment_params)
      notify_customer(@appointment_form.entity)

      redirect_to edit_appointment_path, success: 'Appointment was updated'
    else
      render :edit
    end
  end

  def new
  end

  def create
    if @appointment_form.valid?
      @appointment = Appointment.create(@appointment_form.appointment_params)
      FulfilmentActivity.from(@appointment, current_user)
      notify_customer(@appointment)

      redirect_to booking_requests_path, success: 'Appointment was created'
    else
      render :new
    end
  end

  private

  # rubocop:disable Metrics/MethodLength
  def search_params
    params
      .fetch(:search, {})
      .permit(
        :search_term,
        :appointment_date,
        :status,
        :location,
        :guider,
        :processed,
        :dc_pot_confirmed
      ).merge(
        current_user: current_user,
        page: params[:page]
      )
  end
  # rubocop:enable Metrics/MethodLength

  def notify_customer(appointment)
    if appointment.newly_cancelled?
      AppointmentCancellationNotificationJob.perform_later(appointment)
    elsif appointment.notify?
      AppointmentChangeNotificationJob.perform_later(appointment)
      PrintedConfirmationLetterJob.perform_later(appointment)
    end

    BslCustomerExitPollJob.set(wait: 24.hours).perform_later(appointment) if appointment.bsl_newly_completed?
    PrintedThirdPartyConsentFormJob.perform_later(appointment) if appointment.notify_printed_consent?
    EmailThirdPartyConsentFormJob.perform_later(appointment) if appointment.notify_email_consent?
  end

  def location_aware_appointment
    LocationAwareEntity.new(
      entity: current_user.appointments.find(params[:id]),
      booking_location: booking_location
    )
  end

  def populate_edit_appointment_form
    @activities = location_aware_appointment.activities

    @appointment_form = EditAppointmentForm.new(location_aware_appointment)
  end

  def populate_appointment_form
    @activities = location_aware_booking_request.activities

    @appointment_form = AppointmentForm.new(
      location_aware_booking_request,
      appointment_params
    )
  end

  def location_aware_booking_request
    LocationAwareEntity.new(
      entity: current_user.booking_requests.find(params[:booking_request_id]),
      booking_location: booking_location
    )
  end

  # rubocop:disable Metrics/MethodLength
  def edit_appointment_params
    munge_time_params!

    params
      .require(:appointment)
      .permit(
        :name,
        :email,
        :phone,
        :defined_contribution_pot_confirmed,
        :accessibility_requirements,
        :memorable_word,
        :date_of_birth,
        :guider_id,
        :location_id,
        :additional_info,
        :proceeded_at,
        :status,
        :secondary_status,
        :recording_consent,
        :third_party,
        booking_request_attributes: %i(
          id
          data_subject_name
          data_subject_date_of_birth
          data_subject_consent_obtained
          data_subject_consent_evidence
          power_of_attorney_evidence
          power_of_attorney
          email_consent_form_required
          email_consent
          printed_consent_form_required
          consent_address_line_one
          consent_address_line_two
          consent_address_line_three
          consent_town
          consent_county
          consent_postcode
          bsl
          welsh
        )
      ).merge(current_user: current_user)
  end
  # rubocop:enable Metrics/MethodLength

  def munge_time_params!
    appointment_params = params[:appointment]

    hour   = appointment_params.delete('proceeded_at(4i)')
    minute = appointment_params.delete('proceeded_at(5i)')

    appointment_params[:proceeded_at] += " #{hour}:#{minute}" if hour && minute
  end

  # rubocop:disable Metrics/MethodLength
  def appointment_params
    params
      .fetch(:appointment, {})
      .permit(
        :name,
        :email,
        :phone,
        :defined_contribution_pot_confirmed,
        :accessibility_requirements,
        :memorable_word,
        :date_of_birth,
        :guider_id,
        :location_id,
        :date,
        :time,
        :additional_info
      )
  end
  # rubocop:enable Metrics/MethodLength
end
# rubocop:enable Metrics/ClassLength
