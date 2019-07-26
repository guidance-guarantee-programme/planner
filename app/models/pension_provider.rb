class PensionProvider
  def self.all
    @all ||= JSON.parse(ENV.fetch('PENSION_PROVIDERS', '{}'))
  end

  def self.[](key)
    all[key]
  end
end
