require "securerandom"

describe Twingly::UrlCache do

  subject(:cache) { described_class.new }

  it { is_expected.to respond_to(:cache!) }
  it { is_expected.to respond_to(:cached?) }

  let(:url) { "http://blog.twingly.com/#{SecureRandom.hex}" }

  describe "#cache!" do
    subject { cache.cache!(url) }
    it { is_expected.to be(true) }
  end

  describe "#cached?" do
    context "when uncached" do
      subject { cache.cached?(url) }

      it { is_expected.to be(false) }
    end

    context "when cached" do
      before { cache.cache!(url) }
      subject { cache.cached?(url) }

      it { is_expected.to be(true) }
    end
  end
end
