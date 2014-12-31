module YFAPI
  require_relative 'stock_info'
  require_relative 'constants'
  class Stock
    YFAPI::CATEGORIES.each_value do |cat| 
      cat.each { |meth,val| 
        define_method meth do
          p @collected_data
          if @collected_data[val] == nil
            @collected_data[val] = @stock_info.field(@symbol,val)
          end
          @collected_data[val]
        end
      }
    end
    def initialize(symb)
      @stock_info = YFAPI::StockInfo.new()
      @collected_data = Hash.new
      @symbol = symb
    end
  end
end
