class CalendarResourcePresenter
  attr_reader :id
  attr_reader :title

  def initialize(guider)
    @id    = guider.id
    @title = guider.name
  end
end
