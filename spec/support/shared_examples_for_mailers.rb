RSpec.shared_examples 'mailgun identified email' do
  it 'renders the mailgun identification header' do
    expect(mail['X-Mailgun-Variables'].value).to eq('{"online_booking":true}')
  end
end
