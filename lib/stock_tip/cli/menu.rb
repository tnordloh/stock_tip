module StockTip

  require 'highline/import'
  require_relative '../../yfapi/stock_info'

  module CLI
    TEST = lambda { say "howdy" }
    class Menu
      def initialize()
        @stock_info = YFAPI::StockInfo.new()
      end
      def main_menu(list: TEST , summary: TEST, 
                    portfolio: nil, watchlist: nil)
        choices = %w{watchlist portfolio quit}
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
            menu.choice :portfolio do 
              summary(portfolio)
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
        action = ""
        until (action =~ /quit|q/i )
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
          say "actions:"
          say "  [a] to add a stock to the portfolio"
          say "  [d] to delete a symbol"
          say "  [q] or [quit] to quit to previous menu"
          say "  [enter] to refresh"
          action = ask "action?"
          add_stock(portfolio) if action == "a"
          portfolio.delete(get_symbol()) if action == "d"
        end
      end

      def delete_stock
      end

      def watch_list(watchlist)
        symbol = ""
        watchlist.read_config_file
        until (symbol =~ /quit|q/i )
          say watchlist.to_s
          say "actions:"
          say "  [a symbol] to add a symbol to the watchlist"
          say "  [d symbol] to delete a symbol"
          say "  [r] to refresh"
          say "  [q] or [quit]] to quit to previous menu"
          symbol = ask "actions?"
          command,option = symbol.split(/\s+/)
          edit_fields(watchlist) if command == "f"
          watchlist.add(option.to_s) if command == "a"
          watchlist.delete(option.to_s) if command == "d"
          next if command == "r"
        end
      end

      def edit_fields(watchlist)
        wlf = watchlist.wlf
        p wlf.categories
      end

    end
  end
end
