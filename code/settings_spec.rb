# RAILS_ROOT/spec/config/settings_spec.rb

RSpec.describe Settings do
  it "register without default value" do
    ENV["SOME_TEST_ENV_VAR"] = "settings_test"
    described_class.register :some_test_env_var

    expect(described_class.some_test_env_var).to eq("settings_test")
  end

  it "register with default value" do
    described_class.register :some_test_default, default: "default value"

    expect(described_class.some_test_default).to eq("default value")
  end

  context "different data types" do
    before do
      described_class.register :some_test_bootup_time, default: Time.current
      described_class.register :some_test_false,       default: false
      described_class.register :some_test_true,        default: true
      described_class.register :some_test_number,      default: 5
      described_class.register :some_test_string,      default: "http://example.com"
    end

    it "tests some current setup values", :aggregate_failures do
      expect(described_class.some_test_bootup_time).to be_within(3.minutes).of(Time.current)
      expect(described_class.some_test_false).to       eq(false)
      expect(described_class.some_test_true).to        eq(true)
      expect(described_class.some_test_number).to      eq(5)
      expect(described_class.some_test_string).to      eq("http://example.com")
    end

    it "keeps the correct data types", :aggregate_failures do
      expect(described_class.some_test_bootup_time).to be_a(Time)
      expect(described_class.some_test_false).to       be_a(FalseClass)
      expect(described_class.some_test_true).to        be_a(TrueClass)
      expect(described_class.some_test_number).to      be_a(Integer)
      expect(described_class.some_test_string).to      be_a(String)
    end

    it ".is? compares the values as Strings", :aggregate_failures do
      expect(described_class.is?(:some_test_false, false)).to   eq true
      expect(described_class.is?(:some_test_false, "false")).to eq true

      expect(described_class.is?(:some_test_true, true)).to     eq true
      expect(described_class.is?(:some_test_true, "true")).to   eq true

      expect(described_class.is?(:some_test_number, 5)).to      eq true
      expect(described_class.is?(:some_test_number, "5")).to    eq true
    end
  end
end
