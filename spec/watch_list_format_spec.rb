require 'minitest/autorun'

require_relative '../lib/stock_tip/yaml_interface/watch_list_format'

describe StockTip::WatchListFormat do
  it "lists possible fields" do
    wlf = StockTip::WatchListFormat.new('./data/test')
    list = wlf.categories
    list.keys.each  {|key| puts key}
  end
end
