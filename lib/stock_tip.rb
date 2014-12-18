module StockTip

  def self.cents_to_dollars(cents)
    (cents.to_f / 100).round(2)
  end

  def self.dollars_to_cents(dollars)
    (dollars.round(2)*100).to_i
  end

end
