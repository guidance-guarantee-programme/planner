require 'rails_helper'

RSpec.describe WebHook, '#call' do
  subject { described_class.new }

  context 'when a hook URI is unconfigured' do
    it 'raises an error' do
      expect { subject }.to raise_error(IndexError)
    end
  end

  context 'when a hook URI is configured' do
    let(:json) { Hash[thing: true] }
    let(:body) { '<html/>' }

    let!(:request) do
      stub_request(:post, 'https://example.com/')
        .with(
          body: json.to_json,
          headers: { 'Content-Type' => 'application/json' }
        ).to_return(
          status: status_code,
          body: body
        )
    end

    subject { described_class.new('https://example.com') }

    context 'when successful' do
      let(:status_code) { 200 }

      it 'POSTs the provided JSON payload to the hook URI' do
        subject.call(json)

        expect(request).to have_been_requested
      end
    end

    context 'when not successful' do
      let(:status_code) { 500 }

      it 'raises an error' do
        expect { subject.call(json) }.to raise_error(Faraday::ClientError)
      end
    end
  end
end
