require "data_mapper"
require "bcrypt"

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/db/auth.sqlite")

class User 
  include DataMapper::Resource
  
  attr_accessor :password, :password_confirmation

  property :id,             Serial
  property :email,          String, :required => true, :unique => true, :format => :email_address
  property :password_hash,  Text  
  property :password_salt,  Text
  
  validates_presence_of :password
  validates_confirmation_of :password
  validates_length_of :password, :min => 6

end

DataMapper.finalize
DataMapper.auto_upgrade!

