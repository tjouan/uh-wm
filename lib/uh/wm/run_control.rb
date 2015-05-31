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
          rc.evaluate File.read(rc_path), rc_path if File.exist?(rc_path)
        end
      end

      def initialize env
        @env = env
      end

      def evaluate code, path
        instance_eval code, path
      rescue ::StandardError, ::ScriptError => e
        raise RunControlEvaluationError, e.message, e.backtrace
      end

      def modifier mod
        @env.modifier = mod
      end

      def key *keysyms, &block
        @env.keybinds[translate_keysym *keysyms] = block
      end

      def layout arg, **options
        case arg
        when Class
          if options.any?
            @env.layout = arg.new options
          else
            @env.layout_class = arg
          end
        when Hash
          @env.layout_options = arg
        else
          @env.layout = arg
        end
      end

      def worker type, **options
        @env.worker = [type, options]
      end

      def rule selectors = '', &block
        [*selectors].each { |selector| @env.rules[/\A#{selector}/i] = block }
      end

      def launch &block
        @env.launch = block
      end


      private

      def translate_keysym keysym, modifier = nil
        return [translate_keysym(keysym)[0].to_sym, modifier] if modifier
        translate_key = keysym.to_s.downcase.to_sym
        translated_keysym = KEYSYM_TRANSLATIONS.key?(translate_key) ?
          KEYSYM_TRANSLATIONS[translate_key] :
          translate_key
        keysym =~ /[A-Z]/ ? [translated_keysym, :shift] : translated_keysym
      end
    end
  end
end
