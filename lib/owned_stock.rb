module StockTip
  class OwnedStock
    def initialize(symbol,price_per_share,shares,broker_fee)
      @symbol          = symbol
      @price_per_share = (price_per_share * 100).to_i
      @shares          = shares
      @broker_fee      = (broker_fee * 100).to_i
    end

    attr_reader :shares, :symbol

    def cents_to_dollars(cents)
      cents.to_f / 100
    end
  end
end
