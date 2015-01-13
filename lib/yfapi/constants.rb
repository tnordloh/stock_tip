module YFAPI

  def self.cents_to_dollars(cents)
    (cents.to_f / 100).round(2)
  end

  def self.dollars_to_cents(dollars)
    (dollars.round(2)*100).to_i
  end

  TO_F = lambda { |x| 
    return x if x == "N/A"
    x.to_f
  }
  TO_F_TO_CENTS = lambda { |x| 
    return x if x == "N/A"
    self.dollars_to_cents(x.to_f) 
  }

  NOTHING = lambda { |x| x}

  FIELD_HANDLER = Struct.new(:value,:proc)
  
  PRICING = {
    ask:            FIELD_HANDLER.new('a0',TO_F_TO_CENTS),
    bid:            FIELD_HANDLER.new('b0',TO_F_TO_CENTS),
    ask_realtime:   FIELD_HANDLER.new('b2',TO_F_TO_CENTS),
    bid_realtime:   FIELD_HANDLER.new('b3',TO_F_TO_CENTS),
    previous_close: FIELD_HANDLER.new('p0',TO_F_TO_CENTS),
    open:           FIELD_HANDLER.new('o0',TO_F_TO_CENTS)
  }

  ALL_FIELDS = PRICING

  DIVIDENDS = {
    dividend_yield:             FIELD_HANDLER.new('y',TO_F_TO_CENTS),
    dividend_per_share:         FIELD_HANDLER.new('d',TO_F_TO_CENTS),
    dividend_pay_date:          FIELD_HANDLER.new('r1',NOTHING),
    ex_dividend_date:           FIELD_HANDLER.new('q',NOTHING)
  }

  ALL_FIELDS.merge!(DIVIDENDS)

  DATE = {
    change:                     FIELD_HANDLER.new('c1',TO_F_TO_CENTS),
    change_and_percent_change:  FIELD_HANDLER.new('c0',NOTHING),
    change_realtime:            FIELD_HANDLER.new('c6',NOTHING),
    change_percent:             FIELD_HANDLER.new('k2',NOTHING),
    change_in_percent:          FIELD_HANDLER.new('p2',NOTHING),
    last_trade_date:            FIELD_HANDLER.new('d1',NOTHING),
    trade_date:                 FIELD_HANDLER.new('d2',NOTHING),
    last_trade_time:            FIELD_HANDLER.new('t1',NOTHING)
  }

  ALL_FIELDS.merge!(DATE)

  AVERAGES = {
    after_hours_change:                          FIELD_HANDLER.new('c8',NOTHING),
    commission:                                  FIELD_HANDLER.new('c3',NOTHING),
    days_low:                                    FIELD_HANDLER.new('g0',NOTHING),
    days_high:                                   FIELD_HANDLER.new('h0',NOTHING),
    last_trade_realtime_with_time:               FIELD_HANDLER.new('k1',NOTHING),
    last_trade_with_time:                        FIELD_HANDLER.new('l',NOTHING),
    last_trade_price_only:                       FIELD_HANDLER.new('l1',NOTHING),
    one_year_target_price:                       FIELD_HANDLER.new('t8',NOTHING),
    change_from_200_day_moving_avg:              FIELD_HANDLER.new('m5',NOTHING),
    percent_change_from_200_day_moving_average:  FIELD_HANDLER.new('m6',NOTHING),
    change_from_50_day_moving_avg:               FIELD_HANDLER.new('m7',NOTHING),
    percent_change_from_50_day_moving_avg:       FIELD_HANDLER.new('m8',NOTHING),
    fifty_day_moving_avg:                        FIELD_HANDLER.new('m3',NOTHING),
    two_hundred_day_moving_avg:                  FIELD_HANDLER.new('m4',NOTHING)
  }

  ALL_FIELDS.merge!(AVERAGES)

  FIFTY_TWO_WEEK_PRICING = {
    fifty_two_week_high:                       FIELD_HANDLER.new('k0',TO_F_TO_CENTS),
    fifty_two_week_low:                        FIELD_HANDLER.new('j0',TO_F_TO_CENTS),
    change_from_fifty_two_week_low:            FIELD_HANDLER.new('j5',TO_F_TO_CENTS),
    change_from_fifty_two_week_high:           FIELD_HANDLER.new('k4',TO_F_TO_CENTS),
    percent_change_from_fifty_two_week_low:    FIELD_HANDLER.new('j6',TO_F),
    percent_change_from_fifty_two_week_high:   FIELD_HANDLER.new('k5',TO_F),
    fifty_two_week_range:                      FIELD_HANDLER.new('w0',TO_F_TO_CENTS)
  }

  ALL_FIELDS.merge!(FIFTY_TWO_WEEK_PRICING)

  SYMBOL_INFO = {
    market_capitalization:  FIELD_HANDLER.new('j1',NOTHING),
    market_cap_realtime:    FIELD_HANDLER.new('j3',NOTHING),
    float_shares:           FIELD_HANDLER.new('f6',NOTHING),
    name:                   FIELD_HANDLER.new('n',NOTHING),
    notes:                  FIELD_HANDLER.new('n4',NOTHING),
    symbol:                 FIELD_HANDLER.new('s',NOTHING),
    shares_owned:           FIELD_HANDLER.new('s1',NOTHING),
    stock_exchange:         FIELD_HANDLER.new('x',NOTHING),
    shares_outstanding:     FIELD_HANDLER.new('j2',NOTHING)
  }

  ALL_FIELDS.merge!(SYMBOL_INFO)

  VOLUME = {
    volume:                FIELD_HANDLER.new('v',NOTHING),
    ask_size:              FIELD_HANDLER.new('a5',NOTHING),
    bid_size:              FIELD_HANDLER.new('b6',NOTHING),
    last_trade_size:       FIELD_HANDLER.new('k3',NOTHING),
    average_daily_volume:  FIELD_HANDLER.new('a2',NOTHING)
  }

  ALL_FIELDS.merge!(VOLUME)

  RATIOS = {
    earnings_per_share:                     FIELD_HANDLER.new('e',NOTHING),
    eps_estimate_current_year:              FIELD_HANDLER.new('e7',NOTHING),
    eps_estimate_next_year:                 FIELD_HANDLER.new('e8',NOTHING),
    eps_estimate_next_quarter:              FIELD_HANDLER.new('e9',NOTHING),
    book_value:                             FIELD_HANDLER.new('b4',NOTHING),
    ebitda:                                 FIELD_HANDLER.new('j4',NOTHING),
    price_slash_sales:                      FIELD_HANDLER.new('p5',NOTHING),  
    price_slash_book:                       FIELD_HANDLER.new('p6',NOTHING),  
    pe_ratio:                               FIELD_HANDLER.new('r',NOTHING),  
    pe_ratio_realtime:                      FIELD_HANDLER.new('r2',NOTHING),  
    peg_ratio:                              FIELD_HANDLER.new('r5',NOTHING),  
    price_slash_eps_estimate_current_year:  FIELD_HANDLER.new('r6',NOTHING),  
    price_slash_eps_estimate_next_year:     FIELD_HANDLER.new('r7',NOTHING),  
    short_ratio:                            FIELD_HANDLER.new('s7',NOTHING) 
  }

  ALL_FIELDS.merge!(RATIOS)

  MISC = {
    days_value_change:               FIELD_HANDLER.new('w1',NOTHING),
    days_value_change_realtime:      FIELD_HANDLER.new('w4',NOTHING),
    price_paid:                      FIELD_HANDLER.new('p1',NOTHING),
    days_range:                      FIELD_HANDLER.new('m',NOTHING),
    days_range_realtime:             FIELD_HANDLER.new('m2',NOTHING),
    holdings_gain_percent:           FIELD_HANDLER.new('g1',NOTHING),
    annualized_gain:                 FIELD_HANDLER.new('g3',NOTHING),
    holdings_gain:                   FIELD_HANDLER.new('g4',NOTHING),
    holdings_gain_percent_realtime:  FIELD_HANDLER.new('g5',NOTHING),
    holdings_gain_realtime:          FIELD_HANDLER.new('g6',NOTHING),
    ticker_trend:                    FIELD_HANDLER.new('t7',NOTHING),
    trade_links:                     FIELD_HANDLER.new('t6',NOTHING),
    order_book_realtime:             FIELD_HANDLER.new('i5',NOTHING),
    high_limit:                      FIELD_HANDLER.new('l2',NOTHING),
    low_limit:                       FIELD_HANDLER.new('l3',NOTHING),
    holdings_value:                  FIELD_HANDLER.new('v1',NOTHING),
    holdings_value_realtime:         FIELD_HANDLER.new('v7',NOTHING),
    revenue:                         FIELD_HANDLER.new('s6',NOTHING)
  }

  ALL_FIELDS.merge!(MISC)

  BASE_URL= "http://finance.yahoo.com/d/quotes.csv?s="
  DIVIDER = "&f="
  TAIL = "&e=.csv"

end
