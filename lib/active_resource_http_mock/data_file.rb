require 'active_resource/http_mock'
require 'uri'
require 'yaml'

module ActiveResourceHttpMock
  class DataFile
    def initialize(context)
      @context = context
    end

    def data_dir
      if defined?(Rails)
        File.join(Rails.root, ActiveResourceHttpMock.config.httpmock_path)
      else
        ActiveResourceHttpMock.config.httpmock_path
      end
    end

    def load_mocks
      return unless data_file_exists?

      requests = YAML.load_file(data_file_path).map {|request|
        url = ActiveResourceHttpMock.config.url_decoder.call(request[1])
        request[1] = URI.parse(url).request_uri
        request
      }

      ::ActiveResource::HttpMock.respond_to(false) {|mock|
        requests.each {|request| mock.send *request }
      }
    end

    def dump_mocks(responses)
      yaml = YAML.dump(
        responses.map {|response|
          response[1] = ActiveResourceHttpMock.config.url_encoder.call(response[1])
          response
        }
      )

      File.write data_file_path, yaml
    end

    private

    def data_file_exists?
      File.exists?(data_file_path)
    end

    def data_file_path
      ensure_data_dir!
      File.join(data_dir, @context.to_s) + '.yml'
    end

    def ensure_data_dir!
      Dir.mkdir(data_dir) unless Dir.exist?(data_dir)
    end
  end
end
