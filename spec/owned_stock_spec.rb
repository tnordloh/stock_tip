require 'minitest/autorun'

require_relative '../lib/stock_tip/owned_stock'

describe StockTip::OwnedStock do

  it "can tell me about the stock" do
    stock = StockTip::OwnedStock.new("MCD",100.00,100,9.99,"2014-9-9")
    stock.symbol.must_equal("MCD")
    stock.total_price.must_equal(10_009.99)
    stock.shares.must_equal(100)
    stock.broker_fee.must_equal(9.99)
    stock.purchase_date.month.must_equal(9)
  end

  it "can convert a cent value to the relevant dollar value" do
    StockTip::OwnedStock.cents_to_dollars(100).must_equal(1.00)
  end

  it "can convert a dollar value to the relevant cent value" do
    StockTip::OwnedStock.dollars_to_cents(1.00).must_equal(100)
  end

end
