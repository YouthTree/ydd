module YDD
  autoload :YamlDB,              'ydd/yaml_db'
  autoload :SerializationHelper, 'ydd/serialization_helper'
  
  def self.connection
    ActiveRecord::Base.connection
  end
  
end