# frozen_string_literal: true

require "aws-sdk-sns"

module SnsSender
  class Client
    attr_reader :sns_client

    def initialize
      SnsSender.configuration.validate!
      @sns_client = Aws::SNS::Client.new(
        region: SnsSender.configuration.aws_region,
        credentials: Aws::Credentials.new(
          SnsSender.configuration.aws_access_key_id,
          SnsSender.configuration.aws_secret_access_key
        )
      )
    end

    def publish(topic_arn:, message:, message_attributes: {})
      raise ArgumentError, "topic_arn is required" if topic_arn.nil? || topic_arn.empty?
      raise ArgumentError, "message is required" if message.nil? || message.empty?

      formatted_message = message.is_a?(String) ? message : message.to_json
      formatted_attributes = format_message_attributes(message_attributes)

      begin
        response = sns_client.publish(
          topic_arn: topic_arn,
          message: formatted_message,
          message_attributes: formatted_attributes
        )
        { success: true, message_id: response.message_id }
      rescue Aws::SNS::Errors::ServiceError => e
        raise PublishError, "Failed to publish message: #{e.message}"
      end
    end

    private

    def format_message_attributes(attributes)
      attributes.transform_values do |value|
        {
          data_type: value.is_a?(Numeric) ? "Number" : "String",
          string_value: value.to_s
        }
      end
    end
  end
end
