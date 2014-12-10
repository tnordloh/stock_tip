module StockTip
  class Portfolio
    PORTFOLIO_FILE="portfolio.yaml"
    def initialize(directory)
      @config_file  = "#{directory}/#{PORTFOLIO_FILE}"
      @account_info = nil
    end
  end
end
