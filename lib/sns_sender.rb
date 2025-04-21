# frozen_string_literal: true

require_relative "sns_sender/version"
require_relative "sns_sender/configuration"
require_relative "sns_sender/client"

module SnsSender
  class Error < StandardError; end
  class ConfigurationError < Error; end
  class PublishError < Error; end

  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def publish(topic_arn: nil, message:, message_attributes: {})
      Client.new.publish(
        topic_arn: topic_arn || configuration.default_topic_arn,
        message: message,
        message_attributes: message_attributes
      )
    end

    def reset
      @configuration = Configuration.new
    end
  end
end
