module Uh
  module WM
    class RunControl
      KEYSYM_TRANSLATIONS = {
        backspace:  :BackSpace,
        enter:      :Return,
        return:     :Return,
        tab:        :Tab
      }.freeze

      class << self
        def evaluate env
          rc_path = File.expand_path(env.rc_path)
          rc = new env
          rc.evaluate File.read(rc_path) if File.exist?(rc_path)
        end
      end

      def initialize env
        @env = env
      end

      def evaluate code
        instance_eval code
      end

      def key keysym, &block
        @env.keybinds[translate_keysym keysym] = block
      end


      private

      def translate_keysym keysym
        translate_key = keysym.to_s.downcase.to_sym
        translated_keysym = KEYSYM_TRANSLATIONS.key?(translate_key) ?
          KEYSYM_TRANSLATIONS[translate_key] :
          translate_key
        keysym =~ /[A-Z]/ ? [translated_keysym, :shift] : translated_keysym
      end
    end
  end
end
