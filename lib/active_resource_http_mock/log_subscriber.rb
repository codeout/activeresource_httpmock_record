require 'active_support/log_subscriber'

module ActiveResourceHttpMock
  class LogSubscriber < ActiveSupport::LogSubscriber
    class_attribute :events
    self.events = {}

    def self.responses
      events.values
    end

    def request(event)
      req = compose_event(event)
      events[req[0..1].join('%')] = req
    end

    private

    def compose_event(event)
      [
        event.payload[:method],
        event.payload[:request_uri],
        event.payload[:request].last,
        event.payload[:result].body,
        event.payload[:result].code
      ]
    end
  end
end
