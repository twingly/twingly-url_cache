require "securerandom"

describe Twingly::UrlCache do

  subject(:cache) { described_class.new }

  it { is_expected.to respond_to(:ttl) }
  it { is_expected.to respond_to(:cache!) }
  it { is_expected.to respond_to(:cached?) }

  let(:url) { "http://blog.twingly.com/#{SecureRandom.hex}" }

  describe "#ttl" do
    subject { cache.ttl }

    context "with default ttl (no expire)" do
      it { is_expected.to be(0) }
    end

    context "when set to custom value" do
      let(:ttl) { 3 }
      subject { described_class.new(ttl: ttl).ttl }
      it { is_expected.to be(ttl) }
    end
  end

  describe "#cache!" do
    context "when run once" do
      subject { cache.cache!(url) }
      it { is_expected.to be(true) }
    end

    context "when run multiple times on same key" do
      subject { 14.times.map { cache.cache!(url) } }
      it { is_expected.to all(be(true)) }
    end
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

    context "when expired" do
      let(:ttl) { 1 }
      let(:cache) { described_class.new(ttl: ttl) }

      before do
        cache.cache!(url)
        sleep ttl * 2
      end

      subject { cache.cached?(url) }

      it { is_expected.to be(false) }
    end
  end
end
