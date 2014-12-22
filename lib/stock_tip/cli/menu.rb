module StockTip

  require 'highline/import'
  require_relative '../stock_info'

  module CLI
    TEST = lambda { say "howdy" }
    class Menu
      def initialize()
        @stock_info = StockTip::StockInfo.new()
      end
      def main_menu(list: TEST , summary: TEST, 
                    portfolio: nil, watchlist: nil)
        choices = %w{watchlist summary quit add_stock}
        quit = false
        while quit == false
          choose do |menu|
            say "main menu"
            menu.index        = :letter
            menu.index_suffix = ") "
            menu.prompt       = "choice:"
            menu.choice :watchlist do 
              watch_list(watchlist); 
            end
            menu.choice :summary do 
              summary(portfolio)
              puts "press enter to continue"
              gets 
            end
            menu.choice :add_stock do 
              add_stock(portfolio) 
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

      def add_stock(portfolio)
        symbol = get_symbol() 
        price_per_share = ask("price per share?")
        buy_fee = ask("buy fee? [#{portfolio.account_info[:buy_fee]}]")
        p buy_fee
        p buy_fee.to_s.respond_to?(:to_f)
        buy_fee = portfolio.account_info[:buy_fee]  unless (buy_fee.to_f > 0.0)
        p buy_fee
        shares = ask("number of shares?")
        purchase_date = get_date
        portfolio.add_stock(symbol,
                            price_per_share.to_f,
                            shares.to_i,
                            buy_fee.to_f,
                            purchase_date)
        portfolio.write
      end

      def get_date
        purchase_date = ask("purchase date?")
        while purchase_date !~ /\d{4}-\d{1,2}-\d{1,2}/
          say "purchase date should be formatted like '2014-1-1'"
          purchase_date = ask("purchase date?")
        end
        purchase_date
      end

      def get_symbol()
        symbol = nil
        while(symbol == nil)
          symbol = ask("stock symbol?")
          if @stock_info.price(symbol) == nil
            say "symbol #{symbol} not found. Reprompting:" 
          else
            return symbol
          end
          symbol = nil
        end
      end

      def create_account(account)
        account_info = {}
        account_info[:broker]   = ask("broker name?")
        account_info[:sell_fee] = ask("sell fee?")
        account_info[:buy_fee]  = ask("buy fee?")
        puts "creating account"
        account.write(info: account_info)
      end

      def summary(portfolio)
        stocks = portfolio.info
        column_width=14
        columns = %w[symbol shares price/share broker_fee total_price sell_value 
               current_price ]
        header = columns.map { |c| c.to_s.ljust(column_width) }.join('|')
        spacer = "#{"-" * (columns.size * column_width + columns.size)}"
        say spacer
        say "#{header}\n"
        say spacer
        stocks.each do |stock|
          printme = stock.to_s(column_width)
          say "#{printme}\n"
        end
      end

      def watch_list(watchlist)
        symbol = ""
        watchlist.read_config_file
        until (symbol =~ /quit|q!/i )
          say watchlist.to_s
          symbol = ask "symbol? (enter 'quit' or q! when done)"
          watchlist.add(symbol.to_s)
        end
      end

    end
  end
end
