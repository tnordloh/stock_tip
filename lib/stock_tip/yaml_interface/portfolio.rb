module StockTip
  require_relative 'yaml_interface'
  require_relative '../owned_stock'
  require_relative '../../yfapi/stock_info'
  class Portfolio < StockTip::YamlInterface
    

    PORTFOLIO_FILE="portfolio.yaml"
    def initialize(directory)
      super(directory,PORTFOLIO_FILE)
      @account_info = nil
      @info = []
      self.read_config_file
    end
    
    attr_reader :account_info, :info

    def push(symbol,price_per_share,shares,buy_fee,purchase_date)
      @info << StockTip::OwnedStock.new(symbol,price_per_share,shares,
                                            buy_fee, purchase_date)
      self.write
    end

    def reject!(symbol)
      @info.reject! { |stock| stock.symbol == symbol }
      self.write
    end

    def load_account(account)
      @account_info = account.info
    end

    def sell_value
      StockTip::OwnedStock.sum(*@info, this_method: :sell_value )
    end

  end
end
