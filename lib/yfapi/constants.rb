module YFAPI

  def self.cents_to_dollars(cents)
    (cents.to_f / 100).round(2)
  end

  def self.dollars_to_cents(dollars)
    (dollars.round(2)*100).to_i
  end

  PRICING = {
    ask:                        'a',
    bid:                        'b',
    ask_realtime:               'b2',
    bid_realtime:               'b3',
    previous_close:             'p',
    open:                       'o'
  }

  DIVIDENDS = {
    dividend_yield:             'y',
    dividend_per_share:         'd',
    dividend_pay_date:          'r1',
    ex_dividend_date:           'q'
  }

  DATE = {
    change:                     'c1',
    change_and_percent_change:  'c',
    change_realtime:            'c6',
    change_percent:             'k2',
    change_in_percent:          'p2',
    last_trade_date:            'd1',
    trade_date:                 'd2',
    last_trade_time:            't1'
  }

  AVERAGES = {
    after_hours_change:                          "c8",
    commission:                                  'c3',
    days_low:                                    'g',
    days_high:                                   'h',
    last_trade_realtime_with_time:               'k1',
    last_trade_with_time:                        'l',
    last_trade_price_only:                       'l1',
    one_year_target_price:                       't8',
    change_from_200_day_moving_avg:              'm5',
    percent_change_from_200_day_moving_average:  'm6',
    change_from_50_day_moving_avg:               'm7',
    percent_change_from_50_day_moving_avg:       'm8',
    fifty_day_moving_avg:                        'm7',
    two_hundred_day_moving_avg:                  'm7'
  }

  FIFTY_TWO_WEEK_PRICING = {
    fifty_two_week_high:                       'k',
    fifty_two_week_low:                        'j',
    change_from_fifty_two_week_low:            'j5',
    change_from_fifty_two_week_high:           'k4',
    percent_change_from_fifty_two_week_low:    'j6',
    percent_change_from_fifty_two_week_high:   'k5',
    fifty_two_week_range:                      'w'
  }

  SYMBOL_INFO = {
    more_info:              'v',
    market_capitalization:  'j1',
    market_cap_realtime:    'j3',
    float_shares:           'f6',
    name:                   'n',
    notes:                  'n4',
    symbol:                 's',
    shares_owned:           's1',
    stock_exchange:         'x',
    shares_outstanding:     'j2'
  }

  VOLUME = {
    volume:                'v',
    ask_size:              'a5',
    bid_size:              'b6',
    last_trade_size:       'k3',
    average_daily_volume:  'a2'
  }

  RATIOS = {
    earnings_per_share:                     'e',
    eps_estimate_current_year:              'e7',
    eps_estimate_next_year:                 'e8',
    eps_estimate_next_quarter:              'e9',
    book_value:                             'b4',
    ebitda:                                 'j4',
    price_slash_sales:                      'p5',  
    price_slash_book:                       'p6',  
    pe_ratio:                               'r',  
    pe_ratio_realtime:                      'r2',  
    peg_ratio:                              'r5',  
    price_slash_eps_estimate_current_year:  'r6',  
    price_slash_eps_estimate_next_year:     'r7',  
    short_ratio:                            's7'  
  }

  MISC = {
    days_value_change:               'w1',
    days_value_change_realtime:      'w4',
    price_paid:                      'p1',
    days_range:                      'm',
    days_range_realtime:             'm2',
    holdings_gain_percent:           'g1',
    annualized_gain:                 'g3',
    holdings_gain:                   'g4',
    holdings_gain_percent_realtime:  'g5',
    holdings_gain_realtime:          'g6',
    ticker_trend:                    't7',
    trade_links:                     't6',
    order_book_realtime:             'i5',
    high_limit:                      'l2',
    low_limit:                       'l3',
    holdings_value:                  'v1',
    holdings_value_realtime:         'v7',
    revenue:                         's6'
  }

  BASE_URL= "http://finance.yahoo.com/d/quotes.csv?s="
  DIVIDER = "&f="
  TAIL = "&e=.csv"

end
