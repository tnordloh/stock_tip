module YFAPI
  require_relative 'stock_info'
  require_relative 'constants'
  class Stock

    YFAPI::ALL_FIELDS.each do |method,val| 
      define_method method do
        @data[val] = @stock_info.field(@symbol,method) unless @data[val]
        val.proc.call(@data[val])
      end
    end

    def initialize(symbol)
      @stock_info = YFAPI::StockInfo.new()
      @data = Hash.new
      @symbol = symbol
    end

    def bulk_fetch(*list)
      list.unshift :symbol
      sendme = list.map { |item| YFAPI::ALL_FIELDS[item] }
      fields = @stock_info.get_stock(list,@symbol)
      list.each do |field| 
        @data[field] = fields[@symbol][field]
      end
      @data
    end

    def exist?
      self.symbol() == @symbol
    end

  end
end
