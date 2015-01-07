module StockTip
  class YamlInterface
    
    require 'yaml'
    require 'fileutils'

    def initialize(directory,file)
      @directory = directory
      @config_file = "#{directory}/#{file}"
      @info = { :test => "test_value"}
    end

    attr_reader :config_file, :info, :directory

    def has_data?
      File.exists?(@config_file)
    end

    def method_missing(method, *args)
      return @info[method] || super
    end

    def read_config_file
      if self.has_data?
        @info = YAML.load_file(@config_file)
      end
    end

    def write(info: @info )
      FileUtils::mkdir_p @directory unless Dir.exists?(@directory)
      File.open(@config_file, "w") {|f| f.write info.to_yaml } 
    end

  end
end
