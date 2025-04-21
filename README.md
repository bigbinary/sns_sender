# SNS Sender

A Ruby gem that provides a simple interface for publishing messages to AWS SNS topics, which can then be consumed by SQS queues.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sns_sender'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install sns_sender

## Configuration

Configure the gem with your AWS credentials. In a Rails application, you might want to put this in an initializer:

```ruby
# config/initializers/sns_sender.rb
SnsSender.configure do |config|
  config.aws_region = 'us-east-1'                    # Required
  config.aws_access_key_id = 'YOUR_ACCESS_KEY'       # Required
  config.aws_secret_access_key = 'YOUR_SECRET_KEY'   # Required
  config.default_topic_arn = 'YOUR_DEFAULT_TOPIC_ARN' # Optional
end
```

You can also use environment variables for AWS credentials:
- AWS_REGION
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY

## Usage

### Basic Usage

```ruby
# Send a simple message
SnsSender.publish(
  topic_arn: 'arn:aws:sns:us-east-1:123456789012:MyTopic',
  message: 'Hello, World!'
)

# Send a JSON message
SnsSender.publish(
  topic_arn: 'arn:aws:sns:us-east-1:123456789012:MyTopic',
  message: {
    event: 'user_created',
    data: {
      id: 123,
      name: 'John Doe',
      email: 'john@example.com'
    }
  }
)

# Using the default topic (if configured)
SnsSender.publish(
  message: 'Hello, World!'
)

# With message attributes
SnsSender.publish(
  topic_arn: 'arn:aws:sns:us-east-1:123456789012:MyTopic',
  message: 'Hello, World!',
  message_attributes: {
    event_type: 'greeting',
    priority: 'high'
  }
)
```

### Response Format

The `publish` method returns a hash with the following structure:

```ruby
{
  success: true,
  message_id: 'abc123...' # The SNS message ID
}
```

### Error Handling

The gem can raise the following errors:

```ruby
begin
  SnsSender.publish(topic_arn: 'arn:...', message: 'Hello')
rescue SnsSender::ConfigurationError => e
  # Handle missing or invalid AWS configuration
rescue SnsSender::PublishError => e
  # Handle SNS publishing errors
rescue ArgumentError => e
  # Handle invalid arguments (missing topic_arn or message)
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bigbinary/sns_sender.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
