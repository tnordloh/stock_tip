module YFAPI
  require_relative 'stock_info'
  require_relative 'constants'
  class Stock

    YFAPI::CATEGORIES.each_value do |cat| 
      cat.each do |method,val| 
        define_method method do
          @data[val] = @stock_info.field(@symbol,val) unless @data[val]
        end
      do
    end

    def initialize(symbol)
      @stock_info = YFAPI::StockInfo.new()
      @data = Hash.new
      @symbol = symbol
    end

  end
end
