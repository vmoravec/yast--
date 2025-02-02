require 'yaml'

require "config_agent_service/backend_exception"

module ConfigAgentService
  # Provides chrooting ability
  module ChrootEnv
    # Run block in changed root to dir
    # @param [String] dir of new root
    # @yield code that runs in changed root with all limitations
    # @yieldreturn [Object] Returns return value of block with limitation that for serialization is used YAML, so object to serialize must support it.
    # @note exception is transformed into hash with key error and backtrace or specialized hash for BackendException
    def self.run dir
      rd,wr = IO.pipe
      fork do
        Dir.chroot(dir)
        rd.close
        result = YAML::dump(yield) rescue $!
        result = result.to_hash if result.is_a? BackendException
        result = { "error" => result.message, "backtrace" => result.backtrace } if result.is_a?(Exception)
        wr.write result
        wr.close
        exit 0
      end
      wr.close
      result = YAML::load rd.read
      rd.close
      Process.wait
      return result
    end
  end
end
