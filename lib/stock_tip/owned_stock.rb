module StockTip

  require 'date'

  class OwnedStock
    def initialize(symbol,price_per_share,shares,broker_fee,purchase_date)
      @symbol          = symbol
      @price_per_share = self.class.dollars_to_cents(price_per_share)
      @shares          = shares
      @broker_fee      = self.class.dollars_to_cents(broker_fee)
      @purchase_date   = Date.parse(purchase_date)
    end

    attr_reader :shares, :symbol, :purchase_date

    class << self
      def cents_to_dollars(cents)
        (cents.to_f / 100).round(2)
      end

      def dollars_to_cents(dollars)
        (dollars*100).to_i
      end
    end

    def total_price
      total = @price_per_share * @shares + @broker_fee
      self.class.cents_to_dollars(total)
    end

    def broker_fee
      self.class.cents_to_dollars(@broker_fee)
    end

    def sell_value(current_price,broker_fee)
      current_price = self.class.dollars_to_cents(current_price) 
      broker_fee = self.class.dollars_to_cents(current_price) 
    end

  end
end
