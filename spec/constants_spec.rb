require 'minitest/autorun'

require_relative '../lib/yfapi/constants'

describe YFAPI::constants do
  it "converts dollars to cents" do
    YFAPI::dollars_to_cents(5.23).must_equal(523)
  end

  it "converts cents to dollars" do
    YFAPI::cents_to_dollars(523).must_equal(5.23)
  end

  it "converts string to float" do
    YFAPI::TO_F.call("1.01").must_equal(1.01)
    YFAPI::TO_F.call("N/A").must_equal(nil)
  end

  it "converts string to cents" do
    YFAPI::TO_F_TO_CENTS.call("1.01").must_equal(101)
    YFAPI::TO_F_TO_CENTS.call("N/A").must_equal(nil)
  end
end

