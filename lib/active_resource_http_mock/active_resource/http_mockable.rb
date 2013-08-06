require 'active_resource/connection'
require 'active_resource/http_mock'

module ActiveResourceHttpMock
  module ActiveResource
    module HttpMockable
      def self.included(base)
        base.class_eval do
          private

          def http
            if Thread.current[:httpmock]
              _http_with_mock_
            else
              _http_without_mock_
            end
          end

          def _http_with_mock_
            @http ||= ::ActiveResource::HttpMock.new(@site)
          end

          def _http_without_mock_
            configure_http(new_http)
          end
        end
      end
    end
  end
end

ActiveResource::Connection.send :include, ActiveResourceHttpMock::ActiveResource::HttpMockable
