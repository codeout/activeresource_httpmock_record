require 'active_resource_http_mock/active_resource/http_mockable'
require 'active_resource_http_mock/active_resource/request_loggable'
require 'active_resource_http_mock/configuration'
require 'active_resource_http_mock/rspec' if defined?(RSpec)

module ActiveResourceHttpMock
  class << self
    def configuration
      @configuration ||= ActiveResourceHttpMock::Configuration.new
    end
    alias config configuration

    def configure(&block)
      yield configuration if block_given?
    end
  end
end
