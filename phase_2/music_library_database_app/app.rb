# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  get '/albums' do
    repo = AlbumRepository.new   
    @albums = repo.all
    return erb(:albums)
  end

  get '/albums/new' do
    return erb(:new_album)
  end

  get '/albums/:id' do
    @album_id = params[:id]
    repo = AlbumRepository.new
    repo2 = ArtistRepository.new

    album = repo.find(@album_id)

    @title = album.title
    @release_year = album.release_year
    @artist = repo2.find(album.artist_id).name
    return erb(:albums)
  end

  post '/albums' do
    if invalid_request_parameters_albums?
      status 400
      return ''
    end
    @title = params[:title]
    
    new_album = Album.new
    new_album.title = @title
    new_album.release_year = params[:release_year]
    new_album.artist_id = params[:artist_id]

    repo = AlbumRepository.new
    repo.create(new_album)
    return erb(:album_created)
  end

  get '/artists' do
    repo = ArtistRepository.new
    @artists = repo.all
    return erb(:artists)
  end

  get '/artists/new' do
    return erb(:new_artist)
  end

  get '/artists/:id' do
    @artist_id = params[:id]

    repo = ArtistRepository.new
    @artist = repo.find(@artist_id)
    
    return erb(:artists)
  end

  post '/artists' do
    if invalid_request_parameters_artists?
      status 400
      return ''
    else
      @name = params[:name]
      new_artist = Artist.new
      repo = ArtistRepository.new
      new_artist.name = @name
      new_artist.genre = params[:genre]

      repo.create(new_artist)

      return erb(:artist_created)
    end
  end

  private

  def invalid_request_parameters_albums?
    params[:title] == nil || params[:release_year] == nil || params[:artist_id] == nil
  end

  def invalid_request_parameters_artists?
    params[:name] == nil || params[:genre] == nil
  end
end