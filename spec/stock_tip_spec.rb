require 'minitest/autorun'

require_relative '../lib/stock_tip'

describe StockTip do

  it "can convert a cent value to the relevant dollar value" do
    StockTip.cents_to_dollars(100).must_equal(1.00)
  end

  it "can convert a dollar value to the relevant cent value" do
    StockTip.dollars_to_cents(1.00).must_equal(100)
  end

end
