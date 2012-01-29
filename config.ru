require "sinatra"
require "sinatra/flash"

enable :sessions

require "./helpers"
require "./models"
require "./routes"

run Sinatra::Application
