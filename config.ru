require "sinatra"

enable :sessions

require "./helpers"
require "./models"
require "./routes"

run Sinatra::Application
