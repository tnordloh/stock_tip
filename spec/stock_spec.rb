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
    stock.exists?.must_equal(true)
  end
end
