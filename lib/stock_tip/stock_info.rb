module StockTip
  class StockInfo
    require 'open-uri'
    require 'csv'
    require 'date'

    require_relative '../stock_tip'

    BASE_URL= "http://finance.yahoo.com/d/quotes.csv?s="
    ASK="l1"
    DIVIDEND_PER_SHARE="d"
    EX_DIVIDEND_DATE="q"
    SYMBOL = "s"
    DIVIDER = "&f="
    TAIL = "&e=.csv"

    def price(stock_symbol)
      stock = get_stock([SYMBOL,ASK], stock_symbol)
      return nil if stock["Missing Symbols List."] 
      return nil if stock[stock_symbol] == nil
      dollar_value = stock[stock_symbol][ASK].to_f 
      StockTip.dollars_to_cents(dollar_value) 
    end

    def dividend_info(stock_symbol)
      fields = [SYMBOL,EX_DIVIDEND_DATE,DIVIDEND_PER_SHARE]
      data = get_stock(fields, stock_symbol)
      cents = (data[stock_symbol][DIVIDEND_PER_SHARE].to_f * 100).to_i
      date = Date.parse(data[stock_symbol][EX_DIVIDEND_DATE])
      return { DIVIDEND_PER_SHARE => cents/4, 
               EX_DIVIDEND_DATE   => date
             }
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
