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
    # response = albums.map do |album|
    #   album.title
    # end.join(", ")

    return erb(:index)
  end

  get '/albums/:id' do
    @album_id = params[:id]
    repo = AlbumRepository.new
    repo2 = ArtistRepository.new

    album = repo.find(@album_id)

    @title = album.title
    @release_year = album.release_year
    @artist = repo2.find(album.artist_id).name
    return erb(:index)
  end

  post '/albums' do
    new_album = Album.new
    new_album.title = params[:title]
    new_album.release_year = params[:release_year]
    new_album.artist_id = params[:artist_id]

    repo = AlbumRepository.new
    repo.create(new_album)
    return nil
  end

  get '/artists' do
    repo = ArtistRepository.new

    artists = repo.all

    response = artists.map do |artist|
      artist.name
    end.join(", ")

    return response
  end

  post '/artists' do
    new_artist = Artist.new
    repo = ArtistRepository.new
    new_artist.name = params[:name]
    new_artist.genre = params[:genre]

    repo.create(new_artist)

    return ''
  end
end