class Exclusions
  delegate :include?, to: :holidays

  def holidays
    ['2022-09-19'.to_date]
  end
end
