require 'sinatra/base'
require "sinatra/reloader"

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    return erb(:index)
  end

  post '/hello' do
    @name = params[:name]
    if valid_input?
      return erb(:hello)
    end
    return erb(:index)
  end

  private

  def valid_input?
    !@name.match(/\W/)
  end
end
