module YFAPI
  class StockInfo
    require 'open-uri'
    require 'csv'
    require 'date'
    require 'uri'

    require_relative './constants'

    BASE_URL= "http://finance.yahoo.com/d/quotes.csv?s="
    ASK="l1"
    DIVIDEND_PER_SHARE="d"
    EX_DIVIDEND_DATE="q"
    SYMBOL = "s"
    DIVIDER = "&f="
    TAIL = "&e=.csv"

    def price(stock_symbol)
      symbol = YFAPI::SYMBOL_INFO[:symbol]
      price = YFAPI::AVERAGES[:last_trade_price_only]
      price_fields = [symbol,
                      price
                     ]
      stock = get_stock(price_fields, stock_symbol)
      return nil if !stock || 
                    stock["Missing Symbols List."] ||
                    !stock[stock_symbol]
      dollar_value = stock[stock_symbol][price].to_f 
      YFAPI.dollars_to_cents(dollar_value) 
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

    def field(symbol, row)
      data = get_stock [row],symbol
      data.first[0]
    end

    def get_stock(rows,name)
      parsed_rows = rows.join()
      query = URI.escape(BASE_URL + name + DIVIDER + parsed_rows + TAIL)
      begin
        csv_data = open(query) { |line| CSV.parse(line.read) }       
      rescue Exception => e
        puts "failure: #{e}"
        return nil
      end
      csv_data.inject({}) do |accumulator,line|
        accumulator[line[0]] = rows.zip(line).to_h 
        accumulator
      end
    end
  end
end
