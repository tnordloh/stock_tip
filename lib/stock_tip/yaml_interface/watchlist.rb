module StockTip
  require_relative './yaml_interface'
  require_relative '../stock_info'
  require_relative '../../constants'
  class WatchList < StockTip::YamlInterface
    

    WATCHLIST_FILE="watchlist.yaml"
    def initialize(directory)
      super(directory,WATCHLIST_FILE)
      @info = []
      @stock_info = StockTip::StockInfo.new()
    end
    
    attr_reader :info

    def add(symbol)
      @info << symbol unless @stock_info.price(symbol) == nil
      write
    end

    def delete(symbol)
      @info.delete(symbol)
      write
    end

    def to_s
      header = %w[ SYMBOL ASK EX_DIVIDEND_DATE DIVIDEND_PER_SHARE]
      printme = header.map {|col| col.ljust(16)}.join("|")
      printme = "\n|" + printme + "\n"
      columns = [   SYMBOL,ASK,EX_DIVIDEND_DATE,DIVIDEND_PER_SHARE]
      width=15
      @info.each {|symbol| 
        fields = @stock_info.get_stock(columns,symbol)
        outstring = columns.map() {|col| 
          fields[symbol][col].ljust(16)
        }.join("|")
        printme << "|" + outstring + "\n"
     #   printme = printme + "#{outstring}\n"
      }
      printme
    end

  end
end
