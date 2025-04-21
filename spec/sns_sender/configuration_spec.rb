# frozen_string_literal: true

RSpec.describe SnsSender::Configuration do
  subject(:configuration) { described_class.new }

  describe "#validate!" do
    context "when all required configurations are present" do
      before do
        configuration.aws_region = "us-east-1"
        configuration.aws_access_key_id = "access_key"
        configuration.aws_secret_access_key = "secret_key"
      end

      it "returns true" do
        expect(configuration.validate!).to be true
      end
    end

    context "when required configurations are missing" do
      it "raises ConfigurationError with missing configs" do
        expect { configuration.validate! }.to raise_error(
          SnsSender::ConfigurationError,
          /Missing required AWS configurations: aws_region, aws_access_key_id, aws_secret_access_key/
        )
      end
    end
  end
end
