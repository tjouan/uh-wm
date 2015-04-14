module Uh
  module WM
    class Manager
      INPUT_MASK = Events::SUBSTRUCTURE_REDIRECT_MASK

      attr_reader :modifier, :display

      def initialize events, modifier, display = Display.new
        @events   = events
        @modifier = modifier
        @display  = display
      end

      def connect
        @events.emit :connecting, args: @display
        @display.open
        Display.on_error { fail OtherWMRunningError }
        @display.listen_events INPUT_MASK
        @display.sync false
        Display.on_error { |*args| handle_error *args }
        @display.sync false
        @events.emit :connected, args: @display
      end

      def grab_key keysym, mod = nil
        mod_mask = KEY_MODIFIERS[@modifier]
        mod_mask |= KEY_MODIFIERS[mod] if mod
        @display.grab_key keysym.to_s, mod_mask
      end

      def handle_pending_events
        handle @display.next_event while @display.pending?
      end

      def handle event
        case event.type
        when :key_press
          key_selector = event.modifier_mask & KEY_MODIFIERS[:shift] == 1 ?
            [event.key.to_sym, :shift] :
            event.key.to_sym
          @events.emit :key, *key_selector
        end
      end


      private

      def handle_error *args
        @dispatcher.emit :error, args: args
      end
    end
  end
end
