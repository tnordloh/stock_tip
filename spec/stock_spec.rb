require 'minitest/autorun'

require_relative '../lib/yfapi/stock.rb'

describe YFAPI::Stock do
  it "initializes a stock" do
    stock =  YFAPI::Stock.new("GE")
    stock.symbol.must_equal("GE")
    stock.holdings_gain_percent.must_equal("- - -")
    stock.symbol.must_equal("GE")
  end

  it "checks if a stock exists" do
    stock = YFAPI::Stock.new("GE")
    stock.exist?.must_equal(true)
  end

  it "checks if a stock can return multiple fields" do
    stock = YFAPI::Stock.new("GE")
    data =stock.bulk_fetch(:dividend_per_share, :dividend_pay_date)
    data[:symbol].must_equal("GE")
    data[:dividend_per_share].respond_to?(:to_f).must_equal(true)
    data[:dividend_pay_date].respond_to?(:downcase).must_equal(true)
  end

  it "checks asking" do
    stock = YFAPI::Stock.new("GE")
    stock.ask.must_equal(nil)
  end

  it "checks bid" do
    stock = YFAPI::Stock.new("GE")
    stock.bid.must_equal(nil)
    stock.fifty_two_week_high.class.must_equal(Fixnum)
    stock.change_from_fifty_two_week_high.class.must_equal(Fixnum)
    stock.percent_change_from_fifty_two_week_high.class.must_equal(Float)
  end

end
