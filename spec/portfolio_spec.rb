require 'minitest/autorun'

require_relative '../lib/stock_tip/portfolio'

describe StockTip::Portfolio do
  it "checks if a portfolio exists" do
    portfolio = StockTip::Portfolio.new("./data/empty")
    portfolio.exists?.must_equal(false)
  end
end