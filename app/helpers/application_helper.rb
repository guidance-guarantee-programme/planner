module ApplicationHelper
  def accessibility_requirements(accessibility_requirement)
    accessibility_requirement ? 'Yes' : 'Not requested'
  end
end
