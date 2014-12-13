require 'minitest/autorun'

require_relative '../lib/stock_tip/owned_stock'

describe StockTip::OwnedStock do

  it "can tell me about the stock" do
    stock = StockTip::OwnedStock.new("MCD",100.00,100,9.99)
    stock.symbol.must_equal("MCD")
    stock.total_price.must_equal(10_009.99)
    stock.shares.must_equal(100)
    stock.broker_fee.must_equal(100)
  end

  it "can convert a cent value to the relevant dollar value" do
    stock = StockTip::OwnedStock.new("MCD",100.00,100,9.99)
    stock.cents_to_dollars(100).must_be_within_delta(1.00,0.005)
  end
end
