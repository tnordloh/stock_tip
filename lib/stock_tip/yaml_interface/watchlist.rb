module StockTip
  require_relative 'yaml_interface'
  require_relative 'watch_list_format'
  require_relative '../../yfapi/stock_info'
  require_relative '../../yfapi/stock'
  require_relative '../../yfapi/constants'
  class WatchList < StockTip::YamlInterface
    
    include Enumerable

    WATCHLIST_FILE="watchlist.yaml"
    def initialize(directory)
      super(directory,WATCHLIST_FILE)
      @info = []
      @stock_info = YFAPI::StockInfo.new()
      @wlf = StockTip::WatchListFormat.new(directory)
    end
    
    attr_reader :info, :wlf

    def each
      @info.each {|line| yield line }
    end

    def add(symbol)
      @info << symbol unless @stock_info.price(symbol) == nil
      write
    end

    def delete(symbol)
      @info.delete(symbol)
      write
    end

    def min_shares(symbol, buy_fee: 9.99)
      stock = YFAPI::Stock.new(symbol)
      columns = []
      shares = buy_fee / stock.dividend_per_share.to_f
      (shares*4).ceil
    end

    def best_deal
      columns = []
      columns << YFAPI::SYMBOL_INFO[:symbol]
      columns << YFAPI::AVERAGES[:last_trade_price_only]
      columns << YFAPI::DIVIDENDS[:dividend_per_share] 
      self.max_by do |symbol|
        stock = YFAPI::Stock.new(symbol)
        div =  stock.dividend_per_share.to_f
        price =  stock.last_trade_price_only.to_f
        div/price
      end
    end

    def to_s
      header = %w[ SYMBOL ASK EX_DIVIDEND_DATE DIVIDEND_PER_SHARE YIELD]
      width=19
      printme = header.map {|col| col.ljust(width)}.join("| ")
      printme = "\n| " + printme + "\n"
      printme << "=" * (width * header.size ) + "\n"
      columns = []
      columns << YFAPI::SYMBOL_INFO[:symbol]
      columns << YFAPI::AVERAGES[:last_trade_price_only]
      columns << YFAPI::DIVIDENDS[:ex_dividend_date] 
      columns << YFAPI::DIVIDENDS[:dividend_per_share] 
      columns << YFAPI::DIVIDENDS[:dividend_yield] 
      deal = self.best_deal
      shares = min_shares(deal)
      self.each {|symbol| 
        fields = @stock_info.get_stock(columns,symbol)
        outstring = columns.map() {|col| 
          fields[symbol][col].ljust(width)
        }.join("| ")
        printme << "| " + outstring + "\n"
      }
      price = YFAPI::Stock.new(deal).last_trade_price_only.to_f
      printme << "best deal at this time, based on dividends, is #{deal}\n"
      printme << "buy #{shares} shares for #{price*shares } "+
                 "to get your buy fee back " +
                 "at the next dividend payout\n"
      printme
    end

  end
end
