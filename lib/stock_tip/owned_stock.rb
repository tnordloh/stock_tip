module StockTip

  require 'date'

  require_relative '../stock_tip'

  class OwnedStock
    def initialize(symbol,price_per_share,shares,broker_fee,purchase_date)
      @symbol          = symbol
      @price_per_share = StockTip.dollars_to_cents(price_per_share)
      @shares          = shares
      @broker_fee      = StockTip.dollars_to_cents(broker_fee)
      @purchase_date   = Date.parse(purchase_date)
    end

    attr_reader :shares, :symbol, :purchase_date


    def total_price
      total = @price_per_share * @shares + @broker_fee
      StockTip.cents_to_dollars(total)
    end

    def broker_fee
      StockTip.cents_to_dollars(@broker_fee)
    end

    def sell_value(current_price,broker_fee)
      current_price = StockTip.dollars_to_cents(current_price) 
      broker_fee = StockTip.dollars_to_cents(current_price) 
    end

  end
end
