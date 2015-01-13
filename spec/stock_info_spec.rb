require "minitest/autorun"

require_relative "../lib/yfapi/stock_info"

describe "StockTip::StockInfo" do
  let(:stock_info) { YFAPI::StockInfo.new() } 
  

  it "gets price of a stock" do
    stock_info = YFAPI::StockInfo.new()
    price = stock_info.field("MCD",:last_trade_price_only)
    price.to_f.must_be_within_delta(82,20)
  end

  it "handles aa stock symbol that doesn't exist" do
    stock_info.field("","").must_equal(nil)
    stock_info.field("asfdasdfa","").must_equal(nil)
  end

end
