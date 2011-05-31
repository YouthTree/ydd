require 'yaml'
require 'active_support'
require 'active_support/all'
require 'active_record'
require 'fileutils'
require 'iconv'
require 'rchardet'

module YDD
  class Error < StandardError; end

  autoload :SchemaManager,       'ydd/schema_manager'
  autoload :DataManager,         'ydd/data_manager'
  autoload :YamlDB,              'ydd/yaml_db'
  autoload :SerializationHelper, 'ydd/serialization_helper'
  autoload :Application,         'ydd/application'

  mattr_accessor :skip_schema, :skip_data

  def self.skip_schema?
    !!skip_schema
  end

  def self.schema_tables
    [ 'schema_info', 'schema_migrations' ]
  end

  def self.skip_data?
    !!skip_data
  end

  def self.tables=(value)
    @@tables = value.blank? ? nil : Array(value).join(",").split(",")
  end

  def self.tables
    @@tables ||= nil
  end

  def self.env=(value)
    if value.blank?
      @@env = nil
    else
      @@env = value
    end
  end

  def self.env
    @@env ||= (ENV['YDD_ENV'] || ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development')
  end

  def self.connection
    ActiveRecord::Base.connection
  end

  def self.configuration_from(file)
    require 'erb'
    parsed = ERB.new(File.read(file)).result
    YAML.load(parsed)[env]
  end

  def self.connect_from(path)
    raise Error, "Invalid database config at #{path}" if !File.exists?(path)
    connect configuration_from(path)
  end

  def self.connect(specification)
    ActiveRecord::Base.establish_connection(specification)
  end

  def self.dump(directory)
    FileUtils.mkdir_p directory
    SchemaManager.dump File.join(directory, "schema.rb") unless skip_schema?
    DataManager.dump   File.join(directory, "data.yml")  unless skip_data?
  end

  def self.load(directory)
    if !File.directory?(directory)
      raise Error, "Please provide a valid directory - #{directory} doesn't exist."
    end

    unless skip_schema?
      check_files! directory, "schema.rb"
      SchemaManager.load File.join(directory, "schema.rb")
    end

    unless skip_data?
      check_files! directory, "data.yml"
      DataManager.load   File.join(directory, "data.yml")
    end
  end

  def self.check_files!(dir, *files)
    files.each do |file|
      path = File.join(dir, file)
      raise Error, "#{file} doesn't exist in #{dir}" if !File.readable?(path)
    end
  end

end