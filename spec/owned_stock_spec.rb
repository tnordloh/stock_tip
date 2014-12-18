require 'minitest/autorun'

require_relative '../lib/stock_tip/owned_stock'

describe StockTip::OwnedStock do
  calculator = lambda  { |symbol| 99_99 }
  let(:stock) { StockTip::OwnedStock.new("MCD",100.00,100,9.99,"2014-9-9",calculator) }

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
    stocks << StockTip::OwnedStock.new("GE",100.00,100,9.99,"2014-9-9",calculator)
    StockTip::OwnedStock.sum(*stocks).must_equal(20_019_98)
    StockTip::OwnedStock.sum(*stocks, this_method: :broker_fee).must_equal(1998)
  end

  it "can get a stock's current sell value" do
    sell_value = 99_99 * stock.shares - stock.broker_fee
    stock.sell_value.must_equal(sell_value)
  end

  it "can get a stock's current value" do
    stock.current_price.must_equal(99_99) 
  end

  it "can get a stock's current value" do
    p stock.to_a
  end
  
end
