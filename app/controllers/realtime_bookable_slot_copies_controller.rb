class RealtimeBookableSlotCopiesController < ApplicationController
  layout false

  before_action :load_form

  def new
  end

  def preview
    if @form.valid?
      @good, @bad = *@form.call(preview: true)
    else
      render :new
    end
  end

  def create
    respond_to do |format|
      format.js { @form.call(preview: false) }
    end
  end

  private

  def load_form
    @form = RealtimeBookableSlotCopyForm.new(copy_params)
  end

  def copy_params
    params
      .fetch(:realtime_bookable_slot_copy_form, {})
      .permit(:guider_id, :location_id, :date, :date_range, day_ids: [], slots: [])
      .merge(
        booking_location: booking_location,
        guider_id: params[:guider_id],
        location_id: params[:location_id],
        date: params[:date]
      )
  end
end
