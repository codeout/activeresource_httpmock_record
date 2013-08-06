require 'active_support/notifications'
require 'rspec'
require 'active_resource_http_mock/data_file'
require 'active_resource_http_mock/log_subscriber'

module ActiveResourceHttpMock
  module RSpec
    class << self
      def configure
        ::RSpec.configure do |config|
          config.include self

          config.around :each do |example|
            if (context = example.metadata[:httpmock]) && example.metadata[:js].blank?
              data = ActiveResourceHttpMock::DataFile.new(context)

              if data.load_mocks
                enable_http_mock
                begin
                  example.run
                ensure
                  disable_http_mock
                end
              else
                ActiveResourceHttpMock::LogSubscriber.events.clear
                example.run
                data.dump_mocks ActiveResourceHttpMock::LogSubscriber.responses unless @example.exception
              end
            else
              example.run
            end
          end
        end
      end
    end

    private

    def enable_http_mock
      Thread.current[:httpmock] = true
    end

    def disable_http_mock
      Thread.current[:httpmock] = nil
    end
  end
end

ActiveResourceHttpMock::RSpec.configure
ActiveResourceHttpMock::LogSubscriber.attach_to :active_resource
