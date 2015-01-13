require 'minitest/autorun'

require_relative '../lib/stock_tip/owned_stock'
#require_relative '../lib/stock_tip/stock_info'

describe StockTip::OwnedStock do
  let(:stock) { StockTip::OwnedStock.new("MCD",100.00,100,9.99,"2014-9-9") }

  it "can tell me about the stock" do
    stock.symbol.must_equal("MCD")
    stock.total_purchase_price.must_equal(10_009_99)
    stock.shares.must_equal(100)
    stock.broker_fee.must_equal(999)
    stock.purchase_date.month.must_equal(9)
  end

  it "can sum up multiple stocks" do
    stocks= [] 
    stocks << stock
    stocks << StockTip::OwnedStock.new("GE",100.00,100,9.99,"2014-9-9")
    StockTip::OwnedStock.sum(*stocks).must_equal(20_019_98)
    StockTip::OwnedStock.sum(*stocks, this_method: :broker_fee).must_equal(1998)
  end

  it "can get a stock's current sell value" do
    stock.sell_value.must_be_within_delta(9_155_01,1_000_00)
  end

  it "can get a stock's current value" do
    stock.current_price.must_be_within_delta(91_65,20_00) 
  end

  it "can get turn a stock into an array" do
    stock.to_a[0].must_equal("MCD")
  end

  it "can get turn a stock into a string" do
    p stock.to_s.index("MCD").must_equal(0)
    p stock.to_s
  end
  
  it "can determine how many days a stock has been owned" do
    date = Date.today - 1
    stock = StockTip::OwnedStock.new("MCD",100.00,100,9.99,date.to_s)
    stock.owned_period.must_equal(1)
  end
end
