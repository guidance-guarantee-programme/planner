module Pages
  class Changes < SitePrism::Page
    set_url '/appointments/{id}/changes'

    sections :rows, '.t-change-row' do
      element :label, '.t-label'
      element :before, '.t-before'
      element :after, '.t-after'
    end
  end
end
