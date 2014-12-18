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
      @stock_info      = StockTip::StockInfo.new()
    end

    attr_reader :shares, :symbol, :purchase_date, :broker_fee, 
                :price_per_share

    def total_purchase_price
      @price_per_share * @shares + @broker_fee
    end

    def sell_value()
      current_price * @shares - @broker_fee
    end

    def current_price()
      @stock_info.price(@symbol)
    end

    def self.sum( *owned_stocks, this_method: :total_purchase_price )
      owned_stocks.inject(0) { |sum,stock| sum += stock.send(this_method) }
    end

    def to_a
      [symbol,shares,price_per_share,total_purchase_price,current_price]
    end

    def owned_period
      (Date.today - @purchase_date).to_i
    end

    def to_s(spacer = 14)
      printme = [symbol,
        shares,
        StockTip.cents_to_dollars(price_per_share),
        StockTip.cents_to_dollars(@broker_fee),
        StockTip.cents_to_dollars(total_purchase_price),
        StockTip.cents_to_dollars(sell_value),
        StockTip.cents_to_dollars(current_price),
      ]
      printme.map { |x| x.to_s.ljust(spacer)}.join("|")
    end

  end
end
