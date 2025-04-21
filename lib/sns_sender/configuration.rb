# frozen_string_literal: true

module SnsSender
  class Configuration
    attr_accessor :aws_access_key_id,
                :aws_secret_access_key,
                :aws_region,
                :default_topic_arn

    def initialize
      @aws_region = ENV["AWS_REGION"]
      @aws_access_key_id = ENV["AWS_ACCESS_KEY_ID"]
      @aws_secret_access_key = ENV["AWS_SECRET_ACCESS_KEY"]
    end

    def validate!
      missing_configs = []
      missing_configs << "aws_region" unless aws_region
      missing_configs << "aws_access_key_id" unless aws_access_key_id
      missing_configs << "aws_secret_access_key" unless aws_secret_access_key

      return true if missing_configs.empty?

      raise ConfigurationError, "Missing required AWS configurations: #{missing_configs.join(", ")}"
    end
  end
end
