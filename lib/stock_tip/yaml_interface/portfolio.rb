module StockTip
  require_relative '../yaml_interface'
  class Portfolio < StockTip::YamlInterface
    

    PORTFOLIO_FILE="portfolio.yaml"
    portfolio = []
    def initialize(directory)
      super(directory,ACCOUNT_FILE)
    end
    def add_stock(:symbol = nil, :shares = nil, :total_price = nil)
      portfolio 
    end
  end
end
