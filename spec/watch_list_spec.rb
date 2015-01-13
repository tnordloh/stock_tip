require 'minitest/autorun'

require_relative '../lib/stock_tip/yaml_interface/watchlist'

describe StockTip::WatchList do

  it "creates a watchlist" do
    watch_list = StockTip::WatchList.new('./data/test')
    watch_list.push("GE")
    watch_list.info.must_equal(["GE"])
    watch_list.push("MCD")
    watch_list.info.must_equal(["GE","MCD"])
    watch_list.delete("MCD")
    watch_list.info.must_equal(["GE"])
  end

  it "prints a watchlist" do
    watch_list = StockTip::WatchList.new('./data/test')
    watch_list.push("MCD")
    watch_list.push("GE")
    watch_list.to_s[1,1].must_equal("|")
  end

  it "calculates the best deal in a watchlist" do
    watch_list = StockTip::WatchList.new('./data/test')
    watch_list.push("MCD")
    watch_list.push("GE")
    p watch_list.best_deal 
  end

  it "calculates the minimum shares to by to recoup buy fee in dividends" do
    watch_list = StockTip::WatchList.new('./data/test')
    watch_list.push("MCD")
    watch_list.push("GE")
    p watch_list.min_shares(watch_list.best_deal)
  end

end
