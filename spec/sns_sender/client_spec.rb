# frozen_string_literal: true

RSpec.describe SnsSender::Client do
  let(:aws_credentials) do
    {
      region: "us-east-1",
      aws_access_key_id: "access_key",
      aws_secret_access_key: "secret_key"
    }
  end

  let(:sns_client) { instance_double(Aws::SNS::Client) }
  let(:topic_arn) { "arn:aws:sns:us-east-1:123456789012:MyTopic" }

  before do
    SnsSender.configure do |config|
      config.aws_region = aws_credentials[:region]
      config.aws_access_key_id = aws_credentials[:aws_access_key_id]
      config.aws_secret_access_key = aws_credentials[:aws_secret_access_key]
    end

    allow(Aws::SNS::Client).to receive(:new).and_return(sns_client)
  end

  after do
    SnsSender.reset
  end

  describe "#publish" do
    context "with valid parameters" do
      let(:message) { "test message" }
      let(:response) { instance_double(Aws::SNS::Types::PublishResponse, message_id: "test_message_id") }

      before do
        allow(sns_client).to receive(:publish).and_return(response)
      end

      it "publishes the message successfully" do
        result = described_class.new.publish(topic_arn: topic_arn, message: message)
        
        expect(result).to eq({ success: true, message_id: "test_message_id" })
        expect(sns_client).to have_received(:publish).with(
          topic_arn: topic_arn,
          message: message,
          message_attributes: {}
        )
      end

      context "with message attributes" do
        let(:message_attributes) { { "event_type" => "test" } }
        let(:formatted_attributes) do
          {
            "event_type" => {
              data_type: "String",
              string_value: "test"
            }
          }
        end

        it "includes formatted message attributes" do
          described_class.new.publish(
            topic_arn: topic_arn,
            message: message,
            message_attributes: message_attributes
          )

          expect(sns_client).to have_received(:publish).with(
            topic_arn: topic_arn,
            message: message,
            message_attributes: formatted_attributes
          )
        end
      end
    end

    context "with invalid parameters" do
      it "raises ArgumentError when topic_arn is missing" do
        expect {
          described_class.new.publish(topic_arn: nil, message: "test")
        }.to raise_error(ArgumentError, "topic_arn is required")
      end

      it "raises ArgumentError when message is missing" do
        expect {
          described_class.new.publish(topic_arn: topic_arn, message: nil)
        }.to raise_error(ArgumentError, "message is required")
      end
    end

    context "when SNS client raises an error" do
      before do
        allow(sns_client).to receive(:publish)
          .and_raise(Aws::SNS::Errors::ServiceError.new({}, "SNS Error"))
      end

      it "raises PublishError" do
        expect {
          described_class.new.publish(topic_arn: topic_arn, message: "test")
        }.to raise_error(SnsSender::PublishError, "Failed to publish message: SNS Error")
      end
    end
  end
end
