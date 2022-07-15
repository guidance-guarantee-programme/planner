module Pages
  class Calendar < SitePrism::Page
    set_url '/my_appointments'

    elements :events, '.fc-event'
    elements :resource_cells, '.fc-resource-cell'

    element :filter, '.fc-filter-button'
    element :guider_search, '.select2-search__field'
    element :chosen_guider, '.select2-selection__choice'

    def guiders
      wait_until_resource_cells_visible

      resource_cells.map(&:text)
    end
  end
end
