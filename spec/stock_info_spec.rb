require "minitest/autorun"

require_relative "../lib/stock_tip/stock_info"

describe "StockTip::StockInfo" do
  
  it "gets the price of a stock" do
    stock_info = StockTip::StockInfo.new()
    stock_info.price("MCD").must_be_within_delta(100,45)
  end

  it "gets the dividend information of a stock" do
    stock_info = StockTip::StockInfo.new()
    price = stock_info.dividend_info("MCD")
    price["d"].must_be_within_delta(82,20)
  end
end
