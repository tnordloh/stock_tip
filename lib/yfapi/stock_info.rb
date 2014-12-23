module YFAPI
  class StockInfo
    require 'open-uri'
    require 'csv'
    require 'date'

    require_relative './constants'


    def price(stock_symbol)
      symbol = YFAPI::SYMBOL_INFO[:symbol]
      price = YFAPI::AVERAGES[:last_trade_price_only]
      price_fields = [symbol,
                      price
                     ]
      stock = get_stock(price_fields, stock_symbol)
      return nil if stock["Missing Symbols List."] 
      return nil if stock[stock_symbol] == nil
      dollar_value = stock[stock_symbol][price].to_f 
      YFAPI.dollars_to_cents(dollar_value) 
    end

    def dividend_info(stock_symbol)
      symbol_key        = YFAPI::SYMBOL_INFO[:symbol]
      ex_div_key        = YFAPI::DIVIDENDS[:ex_dividend_date]
      div_per_share_key = YFAPI::DIVIDENDS[:dividend_per_share]
      fields            = [symbol_key,ex_div_key,div_per_share_key]
      data              = get_stock(fields, stock_symbol)
      cents = (data[stock_symbol][div_per_share_key].to_f * 100).to_i
      date  = Date.parse(data[stock_symbol][ex_div_key])
      { div_per_share_key => cents/4, ex_div_key => date }
    end

    def get_stock(rows,name)
      parsed_rows = rows.join()
      query = BASE_URL + name + DIVIDER + parsed_rows + TAIL
      csv_data = open(query) { |line| CSV.parse(line.read) }       
      csv_data.inject({}) do |accumulator,line|
        accumulator[line[0]] = rows.zip(line).to_h 
        accumulator
      end
    end
  end
end
