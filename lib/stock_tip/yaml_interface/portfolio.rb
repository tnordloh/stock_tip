module StockTip
  require_relative '../yaml_interface'
  require_relative '../owned_stock'
  require_relative '../stock_info'
  class Portfolio < StockTip::YamlInterface
    

    PORTFOLIO_FILE="portfolio.yaml"
    def initialize(directory)
      super(directory,PORTFOLIO_FILE)
      @info = []
      @account_info = nil
      @stock_info = StockTip::StockInfo.new()
      @stock_price = lambda { |symbol| @stock_info.price(symbol)}
    end
    
    attr_reader :account_info

    def add_stock(symbol,price_per_share,shares,buy_fee,purchase_date)
      @info << StockTip::OwnedStock.new(symbol,price_per_share,shares,
                                            buy_fee, purchase_date)
    end

    def load_account(account)
      @account_info = account.info
    end

    def sell_value
      StockTip::OwnedStock.sum(*@portfolio, this_method: :sell_value )
    end

  end
end
