# frozen_string_literal: true

RSpec.describe SnsSender do
  it "has a version number" do
    expect(SnsSender::VERSION).not_to be nil
  end

  describe ".configure" do
    after { described_class.reset }

    it "allows setting configuration" do
      described_class.configure do |config|
        config.aws_region = "us-east-1"
        config.aws_access_key_id = "access_key"
        config.aws_secret_access_key = "secret_key"
        config.default_topic_arn = "default:arn"
      end

      config = described_class.configuration
      expect(config.aws_region).to eq("us-east-1")
      expect(config.aws_access_key_id).to eq("access_key")
      expect(config.aws_secret_access_key).to eq("secret_key")
      expect(config.default_topic_arn).to eq("default:arn")
    end
  end

  describe ".publish" do
    let(:client) { instance_double(described_class::Client) }
    let(:message) { "test message" }
    let(:topic_arn) { "test:arn" }
    let(:result) { { success: true, message_id: "test_id" } }

    before do
      allow(described_class::Client).to receive(:new).and_return(client)
      allow(client).to receive(:publish).and_return(result)
    end

    it "delegates to Client#publish" do
      expect(described_class.publish(topic_arn: topic_arn, message: message)).to eq(result)
      expect(client).to have_received(:publish).with(
        topic_arn: topic_arn,
        message: message,
        message_attributes: {}
      )
    end

    context "when default_topic_arn is configured" do
      before do
        described_class.configure do |config|
          config.default_topic_arn = "default:arn"
        end
      end

      after { described_class.reset }

      it "uses default_topic_arn when topic_arn is not provided" do
        described_class.publish(message: message)
        expect(client).to have_received(:publish).with(
          topic_arn: "default:arn",
          message: message,
          message_attributes: {}
        )
      end
    end
  end
end
