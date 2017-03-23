module LogrageFilterer
  protected

  def append_info_to_payload(payload)
    super
    payload[:params] = request.filtered_parameters
  end
end
