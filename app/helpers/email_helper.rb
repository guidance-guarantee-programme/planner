module EmailHelper
  def p(&block) # rubocop:disable Metrics/MethodLength
    content_tag(
      :p,
      capture(&block),
      style: [
        'color: #0B0C0C',
        'font-family: Helvetica, Arial, sans-serif',
        'margin: 15px 0',
        'font-size: 16px',
        'line-height: 1.315789474'
      ].join(';')
    )
  end
end
