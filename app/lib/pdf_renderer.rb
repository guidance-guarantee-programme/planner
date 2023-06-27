class PdfRenderer
  def initialize(appointment)
    @appointment = appointment
  end

  def call
    html = ConsentsController.render(:create, layout: 'pdf', assigns: { appointment: appointment })
    pdf  = Princely::Pdf.new.pdf_from_string(html)

    StringIO.new(pdf)
  end

  private

  attr_reader :appointment
end
