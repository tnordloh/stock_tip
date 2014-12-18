require 'minitest/autorun'

require_relative '../lib/stock_tip/yaml_interface/watchlist'

describe StockTip::WatchList do

  it "creates a watchlist" do
    watch_list = StockTip::WatchList.new('./data/test')
    watch_list.add_stock("GE")
    watch_list.write
    watch_list.info.must_equal(["GE"])
    watch_list.add_stock("MCD")
    watch_list.info.must_equal(["GE","MCD"])
  end

end
