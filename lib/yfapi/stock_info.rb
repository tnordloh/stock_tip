module YFAPI
  class StockInfo
    require 'open-uri'
    require 'csv'
    require 'date'
    require 'uri'

    require_relative './constants'

  
    def field(symbol, row)
      data = get_stock [row],symbol
      return data if data == nil
      data.first[0] 
    end

    def get_stock(rows,name)
      parsed_rows = rows.map {|row| YFAPI::ALL_FIELDS[row].value}
      parsed_rows = parsed_rows.join()
      query = URI.escape(BASE_URL + name + DIVIDER + parsed_rows + TAIL)
      begin
        csv_data = open(query) { |line| CSV.parse(line.read) }       
      rescue Exception => e
        puts "failure: in #{__method__}, #{e}"
        return nil
      end
      if csv_data[0][0] =~ /Missing/
        return nil
      end
      csv_data.inject({}) do |accumulator,line|
        accumulator[line[0]] = rows.zip(line).to_h 
        accumulator
      end
    end
  end
end
