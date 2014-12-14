module StockTip
  require_relative '../yaml_interface'
  require_relative '../owned_stock'
  class Portfolio < StockTip::YamlInterface
    

    PORTFOLIO_FILE="portfolio.yaml"
    portfolio = []
    def initialize(directory)
      super(directory,PORTFOLIO_FILE)
    end
    def add_stock(symbol,price_per_share,shares,broker_fee,purchase_date)
      portfolio << StockTip::OwnedStock.new(symbol,price_per_share,shares,
                                            broker_fee, purchase_date)
    end
    def load_account(account)
      @account = account
    end
  end
end
