module ActiveResourceHttpMock
  class Configuration
    attr_accessor :httpmock_path, :url_encoder, :url_decoder

    def initialize
      self.httpmock_path = 'spec/fixtures/httpmock'
      self.url_encoder   = ->(url) { url }
      self.url_decoder   = ->(url) { url }
    end

    def encode_url(&block)
      @url_encoder = block if block_given?
    end

    def decode_url(&block)
      @url_decoder = block if block_given?
    end
  end
end
