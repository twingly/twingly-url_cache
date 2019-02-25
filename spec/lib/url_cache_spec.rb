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

  shared_examples "memcached exceptions" do |dalli_method_name|
    describe "memcached exception handling" do
      let(:error_message) { "An error has occured!" }
      let(:dalli_error) { dalli_error_class.new(error_message) }

      before do
        allow_any_instance_of(Dalli::Client)
          .to receive(dalli_method_name)
          .and_raise(dalli_error)
      end

      context "when a Dalli::RingError is raised" do
        let(:dalli_error_class) { Dalli::RingError }

        it "should raise a UrlCache::ServerError" do
          expect { subject }.to raise_error(Twingly::UrlCache::ServerError,
                                            error_message)
        end
      end

      context "when a Dalli::DalliError is raised" do
        let(:dalli_error_class) { Dalli::DalliError }

        it "should raise a UrlCache::Error" do
          expect { subject }.to raise_error(Twingly::UrlCache::Error,
                                            error_message)
        end
      end
    end
  end

  describe "#cache!" do
    subject(:cache!) { cache.cache!(url) }

    context "when run once" do
      it { is_expected.to be(true) }
    end

    context "when run multiple times on same key" do
      subject { 14.times.map { cache! } }

      it { is_expected.to all(be(true)) }
    end

    include_examples "memcached exceptions", :set
  end

  describe "#cached?" do
    subject { cache.cached?(url) }

    context "when uncached" do
      it { is_expected.to be(false) }
    end

    context "when cached" do
      before { cache.cache!(url) }

      it { is_expected.to be(true) }
    end

    context "when expired" do
      let(:ttl) { 1 }
      let(:cache) { described_class.new(ttl: ttl) }

      before do
        cache.cache!(url)
        sleep ttl * 2
      end

      it { is_expected.to be(false) }
    end

    include_examples "memcached exceptions", :get
  end
end
