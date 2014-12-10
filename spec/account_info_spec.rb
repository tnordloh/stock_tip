require 'minitest/autorun'

require_relative '../lib/stock_tip/account_info'

describe StockTip::AccountInfo do
  it "checks if your broker information exists already" do
    account = StockTip::AccountInfo.new("./data/empty")
    account.exists?.must_equal(false)
  end
  
  it "creates a new account" do
    account = StockTip::AccountInfo.new("./data/test")
    account.create_account(account: { :name => "Ameritrade", 
                                  :buy_fee => 999,
                                  :sell_fee => 1002 } )
    account.exists?.must_equal(true)
    File.delete(account.config_file)
  end
end
