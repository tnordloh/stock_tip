module StockTip

  require 'date'

  require_relative '../stock_tip'
  require_relative './stock_info'

  class OwnedStock
    def initialize(symbol,price_per_share,shares,broker_fee,purchase_date)
      @symbol          = symbol
      @price_per_share = StockTip.dollars_to_cents(price_per_share)
      @shares          = shares
      @broker_fee      = StockTip.dollars_to_cents(broker_fee)
      @purchase_date   = Date.parse(purchase_date)
    end

    attr_reader :shares, :symbol, :purchase_date, :broker_fee


    def total_purchase_price
      @price_per_share * @shares + @broker_fee
    end


    def sell_value()
      value = current_price * @shares - @broker_fee
    end

    def current_price()
      info = StockTip::StockInfo.new
      info.price(@symbol)
    end

    def self.sum( *owned_stocks, this_method: :total_purchase_price )
      owned_stocks.inject(0) { |sum,stock| sum += stock.send(this_method) }
    end

  end
end
