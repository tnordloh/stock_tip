module StockTip

  require 'highline/import'
  TEST= lambda { say "howdy" } 
  class CLI
    def self.main_menu(list: TEST , summary: TEST, 
                      portfolio: nil)
      choices = %w{list summary quit add_stock}
      quit = false
      while quit == false
        choose do |menu|
          say "main menu"
          menu.index        = :letter
          menu.index_suffix = ") "
          menu.prompt       = "choice:"
          menu.choice :list do
            list.call 
          end
          menu.choice :summary do 
            summary.call; 
            puts "press enter to continue"
            gets 
          end
          menu.choice :add_stock do 
            StockTip::CLI::add_stock(portfolio) 
            summary.call
            puts "press enter to continue"
            gets 
          end
          menu.choice :quit do 
            quit = true 
          end
        end
      end
    end

    def self.add_stock(portfolio)
      symbol = ask("stock symbol?")
      price_per_share = ask("price per share?")
      buy_fee = ask("buy fee? [#{portfolio.account_info[:buy_fee]}]")
      buy_fee = portfolio.account_info.buy_fee  unless buy_fee.to_s.respond_to?(:to_f)
      shares = ask("number of shares?")
      purchase_date = ask("purchase date?")
      portfolio.add_stock(symbol,
                          price_per_share.to_f,
                          shares.to_i,
                          buy_fee.to_i,
                          purchase_date)
      portfolio.create
    end
  end
end
