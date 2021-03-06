module Uh
  module WM
    class Env < Baf::Env
      RC_PATH = '~/.uhwmrc.rb'.freeze

      MODIFIER  = :mod1
      KEYBINDS  = {
        [:q, :shift] => proc { quit }
      }.freeze
      WORKER    = :block

      LOGGER_LEVEL          = Logger::WARN
      LOGGER_LEVEL_VERBOSE  = Logger::INFO
      LOGGER_LEVEL_DEBUG    = Logger::DEBUG
      LOGGER_LEVEL_STRINGS  = %w[DEBUG INFO WARN ERROR FATAL UNKNOWN].freeze

      extend Forwardable
      def_delegator :logger, :info,   :log
      def_delegator :logger, :fatal,  :log_fatal
      def_delegator :logger, :error,  :log_error
      def_delegator :logger, :debug,  :log_debug

      attr_reader   :keybinds
      attr_accessor :rc_path, :modifier, :modifier_ignore, :worker, :layout,
                    :layout_class, :layout_options, :rules, :launch

      def initialize **_
        super
        @rc_path          = RC_PATH
        @modifier         = MODIFIER
        @modifier_ignore  = []
        @keybinds         = KEYBINDS.dup
        @layout_options   = {}
        @worker           = WORKER
        @rules            = {}
      end

      def layout
        @layout ||= if layout_class
          layout_class.new @layout_options
        else
          require 'uh/layout'
          ::Uh::Layout.new(@layout_options)
        end
      end

      def logger
        @logger ||= Logger.new(@output).tap do |o|
          o.level = debug? ? LOGGER_LEVEL_DEBUG :
            verbose? ? LOGGER_LEVEL_VERBOSE :
            LOGGER_LEVEL
          o.formatter = LoggerFormatter.new
        end
      end

      def log_logger_level
        log "Logging at #{LOGGER_LEVEL_STRINGS[logger.level]} level"
      end
    end
  end
end
