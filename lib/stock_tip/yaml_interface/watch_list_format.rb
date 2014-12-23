module StockTip
  require_relative 'yaml_interface'
  require_relative '../../yfapi/stock_info'
  require_relative '../../yfapi/constants'
  class WatchListFormat < StockTip::YamlInterface
    WATCH_LIST_FORMAT="watchlist_format.yaml"

    def initialize(directory)
      super(directory,WATCH_LIST_FORMAT)
    end

    def categories
      list = {}
      YFAPI.constants.each {|constant|
        x =  instance_eval "YFAPI::#{constant}"
        next unless x.is_a?(Hash)
        list[constant]  = x
      }
      list
    end

  end
end
