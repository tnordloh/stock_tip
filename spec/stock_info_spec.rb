require "minitest/autorun"

require_relative "../lib/stock_info"

describe "StockTip::StockInfo" do
  
  it "gets the price of a stock" do
    stock_info = StockTip::StockInfo.new()
    price = stockinfo.price("MCD").must_be_within_delta(100,45)
  end

end
