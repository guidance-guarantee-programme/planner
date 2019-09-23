class PensionProvider
  def self.all
    @all ||= JSON.parse(
      ENV.fetch('PENSION_PROVIDERS', '{}')
    ).merge('n/a' => 'Not Applicable')
  end

  def self.[](key)
    all[key]
  end
end
