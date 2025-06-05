class BslController < ApplicationController
  def create
    toggle_bsl_slot!('The slot is now ready for BSL/double appointments')
  end

  def destroy
    toggle_bsl_slot!('The slot is now reverted from BSL/double appointments')
  end

  private

  def toggle_bsl_slot!(message)
    @slot = BookableSlot.find(params[:id])
    @slot.toggle!(:bsl) # rubocop:disable Rails/SkipsModelValidations

    redirect_back fallback_location: schedules_path, success: message
  end
end
