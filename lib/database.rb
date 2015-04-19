require 'mongo'

class Database
  MONGO_ENDPT = '127.0.0.1'
  DATABASE = "trophi_#{ENV['RUBY_ENV'] || 'development'}"

  @@client = nil;
  @@database = nil;

  def self.[] (collection)
    return self.connect[collection]
  end

  def self.connect
    self.active_connection? ? @@database : self.send(:conjure_connection)
  end

  def self.active_connection?
    return !@@database.nil? && !@@database.connection.nil? && @@database.connection.active?
  end

  def self.close
    @@database.connection.close if self.active_connection?
    @@database = @@client = nil
  end

  def self.conjure_connection
    @@client = Mongo::MongoClient.new(MONGO_ENDPT, 27017, :pool_size => 8)
    @@database = @@client[DATABASE]
  end

  at_exit { self.close }
end
