require 'active_resource/connection'
require 'active_support/notifications'

module ActiveResourceHttpMock
  module ActiveResource
    module RequestLoggable
      def self.included(base)
        base.class_eval do
          private

          # OPTIMIZE: It looks hard to swap Connection object with modified one as ActiveResource::* works together monolithically
          def request(method, path, *arguments)
            result = ActiveSupport::Notifications.instrument("request.active_resource") do |payload|
              payload[:method]      = method
              payload[:request_uri] = "#{site.scheme}://#{site.host}:#{site.port}#{path}"
              payload[:request]     = arguments  # monkey patch for request logging
              payload[:result]      = http.send(method, path, *arguments)
            end
            handle_response(result)
          rescue Timeout::Error => e
            raise TimeoutError.new(e.message)
          rescue OpenSSL::SSL::SSLError => e
            raise SSLError.new(e.message)
          end
        end
      end
    end
  end
end

ActiveResource::Connection.send :include, ActiveResourceHttpMock::ActiveResource::RequestLoggable
