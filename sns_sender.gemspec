# frozen_string_literal: true

require_relative "lib/sns_sender/version"

Gem::Specification.new do |spec|
  spec.name = "sns_sender"
  spec.version = SnsSender::VERSION
  spec.authors = ["Unnikrishnan KP"]
  spec.email = ["unnikrishnan.kp@bigbinary.com"]

  spec.summary = "A Ruby gem for publishing messages to AWS SNS topics"
  spec.description = "A simple interface for publishing messages to AWS SNS topics that can be consumed by SQS queues"
  spec.homepage = "https://github.com/bigbinary/sns_sender"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  
  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.glob("{lib}/**/*") + %w(README.md LICENSE.txt)
  spec.require_paths = ["lib"]

  # Runtime dependencies
  spec.add_dependency "aws-sdk-sns", "~> 1.0"

  # Development dependencies
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 1.21"
  spec.add_development_dependency "nokogiri", "~> 1.15"
  spec.add_development_dependency "aws-sdk-core", "~> 3.0"
end
