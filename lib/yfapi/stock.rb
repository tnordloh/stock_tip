module YFAPI
  require_relative 'stock_info'
  require_relative 'constants'
  class Stock

    YFAPI::CATEGORIES.each_value do |cat| 
      cat.each { |method,val| 
        define_method method do
          unless @collected_data[val]
            @collected_data[val] = @stock_info.field(@symbol,val)
          end
          #@collected_data[val]
        end
      }
    end

    def initialize(symbol)
      @stock_info = YFAPI::StockInfo.new()
      @collected_data = Hash.new
      @symbol = symbol
    end

  end
end
