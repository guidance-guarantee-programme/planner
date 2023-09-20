require 'rails_helper'

RSpec.describe PusherHelper do
  module CurrentUser
    def current_user
      @current_user ||= FactoryBot.build_stubbed(:hackney_booking_manager)
    end
  end

  before do
    helper.extend(CurrentUser)
  end

  describe '#pusher_configured?' do
    context 'when PusherFake is defined' do
      before do
        stub_const('PusherFake', true)
      end

      context 'and PUSHER_KEY is set' do
        before do
          allow(ENV).to receive(:[]).with('PUSHER_KEY').and_return('pusher_key')
        end

        it 'returns true' do
          expect(helper.pusher_configured?).to be_truthy
        end
      end

      context 'and PUSHER_KEY is not set' do
        before do
          allow(ENV).to receive(:[]).with('PUSHER_KEY').and_return(nil)
        end

        it 'returns true' do
          expect(helper.pusher_configured?).to be_truthy
        end
      end
    end

    context 'when PusherFake is not defined' do
      before do
        hide_const('PusherFake')
      end

      context 'and PUSHER_KEY is set' do
        before do
          allow(ENV).to receive(:[]).with('PUSHER_KEY').and_return('pusher_key')
        end

        it 'returns true' do
          expect(helper.pusher_configured?).to be_truthy
        end
      end

      context 'and PUSHER_KEY is not set' do
        before do
          allow(ENV).to receive(:[]).with('PUSHER_KEY').and_return(nil)
        end

        it 'returns false' do
          expect(helper.pusher_configured?).to be_falsey
        end
      end
    end
  end

  describe '#pusher_javascript' do
    context 'when PusherFake is defined' do
      let(:pusher_fake) do
        Class.new do
          def self.javascript
            'new Pusher("pusher_key",{"wsHost":"127.0.0.1","wsPort":61336,"cluster":"us-east-1"});'
          end
        end
      end

      before do
        stub_const('PusherFake', pusher_fake)
      end

      it 'returns the PusherFake javascript' do
        expect(helper.pusher_javascript).to eq %(
          Pusher.instance = new Pusher("pusher_key",{"wsHost":"127.0.0.1","wsPort":61336,"cluster":"us-east-1"});
        ).strip
      end
    end

    context 'when PusherFake is not defined' do
      before do
        hide_const('PusherFake')
        allow(ENV).to receive(:[]).with('PUSHER_KEY').and_return('pusher_key')
      end

      it 'returns the real javascript' do
        expect(helper.pusher_javascript).to eq %(
          Pusher.instance = new Pusher("pusher_key", { cluster: "eu", encrypted: true });
        ).strip
      end
    end
  end

  # rubocop:disable Layout/LineLength
  describe '#pusher_module_tag' do
    it 'returns a <div> tag with the correct attributes' do
      expect(helper.pusher_module_tag).to eq %(
        <div data-module="drop-notifications" data-config="{&quot;event&quot;:&quot;ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef&quot;}"></div>
      ).strip
    end
  end
  # rubocop:enable Layout/LineLength

  describe '#pusher_script_tag' do
    let(:javascript) { 'Pusher.instance = new Pusher("pusher_key", { cluster: "eu", encrypted: true });' }

    before do
      allow(helper).to receive(:pusher_javascript).and_return(javascript)
    end

    it 'returns a <script> tag with the correct javascript' do
      expect(helper.pusher_script_tag).to eq %(
        <script>Pusher.instance = new Pusher("pusher_key", { cluster: "eu", encrypted: true });</script>
      ).strip
    end
  end

  describe '#pusher_setup' do
    context 'when pusher_configured? returns false' do
      before do
        allow(helper).to receive(:pusher_configured?).and_return(false)
      end

      it 'returns nil' do
        expect(helper.pusher_setup).to be_nil
      end
    end

    context 'when current_user is not a booking manager' do
      before do
        allow(helper).to receive(:pusher_configured?).and_return(true)
        allow(helper.current_user).to receive(:booking_manager?).and_return(false)
      end

      it 'returns nil' do
        expect(helper.pusher_setup).to be_nil
      end
    end

    context 'when pusher is configured and the current user is a booking manager' do
      let(:pusher_fake) do
        Class.new do
          def self.javascript
            'new Pusher("pusher_key",{"wsHost":"127.0.0.1","wsPort":61336,"cluster":"us-east-1"});'
          end
        end
      end

      before do
        stub_const('PusherFake', pusher_fake)

        allow(helper).to receive(:pusher_configured?).and_return(true)
        allow(helper.current_user).to receive(:booking_manager?).and_return(true)
      end

      it 'returns the module and script tags' do
        expect(helper.pusher_setup).to eq <<~HTML.strip
          <script>Pusher.instance = new Pusher("pusher_key",{"wsHost":"127.0.0.1","wsPort":61336,"cluster":"us-east-1"});</script>
          <div data-module="drop-notifications" data-config="{&quot;event&quot;:&quot;ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef&quot;}"></div>
        HTML
      end
    end
  end
end
