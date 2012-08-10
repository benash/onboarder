require 'sinatra/base'
require 'mustache/sinatra'

class App < Sinatra::Base
  register Mustache::Sinatra
  require 'views/layout'
  require 'tasks'
  require 'user_agent'
  require 'models/cookie'

  include Tasks

  set :mustache, {
    :views => 'views/',
    :templates => 'templates/'
  }

  get '/' do
    @title = 'OnBoarder'
    @agent = UserAgent.new(request.user_agent).name

    mustache :index
  end
end
