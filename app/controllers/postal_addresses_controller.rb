class PostalAddressesController < ApplicationController
  before_action :fetch_booking_request
  before_action :populate_postal_address

  def edit
  end

  def update
    if @postal_address.update(postal_address_params)
      redirect_to destination_url
    else
      render :edit
    end
  end

  private

  def fetch_booking_request
    @booking_request = current_user.booking_requests.find(params[:booking_request_id])
  end

  def populate_postal_address
    @postal_address = PostalAddressForm.new(@booking_request)
  end

  def postal_address_params
    params
      .fetch(:postal_address, {})
      .permit(
        :address_line_one,
        :address_line_two,
        :address_line_three,
        :town,
        :county,
        :postcode
      )
  end

  def destination_url
    if @booking_request.appointment
      edit_appointment_url(@booking_request.appointment)
    else
      new_booking_request_appointment_url(@booking_request)
    end
  end
end
