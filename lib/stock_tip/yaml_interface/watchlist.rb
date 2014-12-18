module StockTip
  require_relative '../yaml_interface'
  require_relative '../stock_info'
  class WatchList < StockTip::YamlInterface
    

    WATCHLIST_FILE="watchlist.yaml"
    def initialize(directory)
      super(directory,WATCHLIST_FILE)
      @info = []
      @account_info = nil
      @stock_info = StockTip::StockInfo.new()
    end
    
    attr_reader :info

    def add_stock(symbol)
      @info << symbol unless @stock_info.price(symbol) == nil
    end

  end
end
