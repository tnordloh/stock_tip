module StockTip
  class YamlInterface
    
    require 'yaml'
    require 'fileutils'

    def initialize(directory,file)
      @directory = directory
      @config_file = "#{directory}/#{file}"
      @info = { :test => "test_value"}
    end

    attr_reader :config_file, :info

    def exists?
      File.exists?(@config_file)
    end

    def method_missing(method, *args)
      return @info[method] || super
    end

    def read_config_file
      unless exists?
        raise "file #{config_file} nonexistent.  use create_account to create"
      end
      @info = YAML.load_file(@config_file)
    end

    def create(info: @info )
      puts @directory
      FileUtils::mkdir_p @directory 
      File.open(@config_file, "w") {|f| f.write info.to_yaml } 
    end

  end
end
