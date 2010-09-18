module YDD
  class DataManager
    
    def self.dump(path)
      SerializationHelper::Base.new(YamlDB::Helper).dump path
    end
    
    def self.load(path)
      if File.exists?(path)
        SerializationHelper::Base.new(YamlDB::Helper).load path
      end
    end
    
  end
end