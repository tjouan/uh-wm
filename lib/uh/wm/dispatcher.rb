module Uh
  module WM
    class Dispatcher
      attr_reader :hooks

      def initialize
        @hooks = Hash.new { |h, k| h[k] = [] }
      end

      def [] *key
        @hooks[translate_key key]
      end

      def on *key, &block
        @hooks[translate_key key] << block
      end

      def emit *key
        @hooks[translate_key key].each { |e| e.call }
      end


      private

      def translate_key key
        key.one? ? key[0] : key
      end
    end
  end
end
