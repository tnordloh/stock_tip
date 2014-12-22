require "minitest/autorun"

require_relative "../lib/yfapi/stock_info"

describe "StockTip::StockInfo" do
  let(:stock_info) { YFAPI::StockInfo.new() } 
  
  it "gets the price of a stock" do
    stock_info.price("MCD").must_be_within_delta(9062,45_00)
  end

  it "gets the dividend information of a stock" do
    stock_info = YFAPI::StockInfo.new()
    price = stock_info.dividend_info("MCD")
    price["d"].must_be_within_delta(82,20)
  end

  it "handles aa stock symbol that doesn't exist" do
    stock_info.price("").must_equal(nil)
    p stock_info.price("asfdasdfa").must_equal(nil)
  end
end
