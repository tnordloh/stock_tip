module StockTip
  require_relative 'yaml_interface'
  require_relative 'watch_list_format'
  require_relative '../../yfapi/stock_info'
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

    def best_deal
      columns = []
      columns << YFAPI::SYMBOL_INFO[:symbol]
      columns << YFAPI::AVERAGES[:last_trade_price_only]
      columns << YFAPI::DIVIDENDS[:dividend_per_share] 
      self.max_by do |symbol|
        fields = @stock_info.get_stock(columns,symbol)
        div =  fields[symbol][YFAPI::DIVIDENDS[:dividend_per_share]].to_f
        price =  fields[symbol][YFAPI::AVERAGES[:last_trade_price_only]].to_f
        div/price
      end
    end

    def to_s
      header = %w[ SYMBOL ASK EX_DIVIDEND_DATE DIVIDEND_PER_SHARE]
      printme = header.map {|col| col.ljust(16)}.join("|")
      printme = "\n|" + printme + "\n"
      columns = []
      columns << YFAPI::SYMBOL_INFO[:symbol]
      columns << YFAPI::AVERAGES[:last_trade_price_only]
      columns << YFAPI::DIVIDENDS[:ex_dividend_date] 
      columns << YFAPI::DIVIDENDS[:dividend_per_share] 
      width=15
      self.each {|symbol| 
        fields = @stock_info.get_stock(columns,symbol)
        outstring = columns.map() {|col| 
          fields[symbol][col].ljust(16)
        }.join("|")
        printme << "|" + outstring + "\n"
      }
      printme
    end

  end
end
