require 'minitest/autorun'

require_relative '../lib/account_info'

describe StockTip::AccountInfo do
  it "checks if your broker information exists already" do
    account = StockTip::AccountInfo.new("./data/empty")
    account.exists?.must_equal(false)
  end
end
