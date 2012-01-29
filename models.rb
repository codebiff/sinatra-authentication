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
  property :token,          Text
  
  validates_with_method :confirm_password

  def confirm_password
    if password == password_confirmation
      return true
    else
      [false, "Password and Password confirmation do not match"]
    end    
  end

end

DataMapper.finalize
DataMapper.auto_upgrade!

