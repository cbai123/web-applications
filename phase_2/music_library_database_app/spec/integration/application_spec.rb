require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context "GET /albums" do
    it 'returns 200 OK' do
      # Assuming the post with id 1 exists.
      response = get('/albums')

      # expected_response = "Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring"

      expect(response.status).to eq(200)
      # expect(response.body).to eq(expected_response)
      expect(response.body).to include('Title: Surfer Rosa')
      expect(response.body).to include('Released: 202')
      expect(response.body).to include('Title: Ring Ring')
    end
  end

  context "GET /albums/id" do
    it 'returns 200 OK' do
      # Assuming the post with id 1 exists.
      response = get('/albums/2')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Surfer Rosa</h1>')
      expect(response.body).to include('Artist: Pixies')
    end

    it 'returns 200 OK' do
      # Assuming the post with id 1 exists.
      response = get('/albums/3')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Waterloo</h1>')
      expect(response.body).to include('Release year: 1974')
    end
  end

  context "GET /albums/new" do
    it "returns the form" do
      response = get('/albums/new')

      expect(response.status).to eq(200)

      expect(response.body).to include("Add an album")
      expect(response.body).to include('<form method = "POST" action = "/albums">')
      expect(response.body).to include('<input type = "text" name = "title">')
      expect(response.body).to include('<input type = "int" name = "release_year">')
      expect(response.body).to include('<input type = "int" name = "artist_id">')

      expect(response.body).to include('<input type = "submit" value = "Submit">')
    end
  end

  context "POST /albums" do
    it "creates album and returns confirmation screen" do
      response = post('/albums', title: "Voyage", release_year: 2022, artist_id: 2)

      expect(response.status).to eq(200)
      expect(response.body).to include("You added Voyage to albums")
      
      response = get('/albums')
      expect(response.body).to include("Voyage")
    end

    it "creates album and returns confirmation screen with different name" do
      response = post('/albums', title: "OK Computer", release_year: 1997, artist_id: 1)

      expect(response.status).to eq(200)
      expect(response.body).to include("You added OK Computer to albums")

      response = get('/albums')
      expect(response.body).to include("OK Computer")
    end

    it "returns 400 if invalid input" do
      response = post('/albums', title: "title", release_year: nil, artist_id: 1)

      expect(response.status).to eq(400)
    end

    it "returns 400 if invalid input" do
      response = post('/albums', ttitle: "title")

      expect(response.status).to eq(400)
    end
  end

  context "GET /artists" do
    it 'returns 200 OK' do
      response = get('/artists')
      expected_response = 'Pixies, ABBA, Taylor Swift, Nina Simone, Kiasmos'

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Artists:</h1>')
      expect(response.body).to include('Name: Pixies')
      expect(response.body).to include('Artist Page')
      expect(response.body).to include('Name: Taylor Swift')
    end
  end

  context "GET /artists/id" do
    it 'returns 200 OK' do
      # Assuming the post with id 1 exists.
      response = get('/artists/2')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>ABBA</h1>')
      expect(response.body).to include('Genre: Pop')
    end

    it 'returns 200 OK' do
      response = get('artists/4')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Nina Simone</h1>')
      expect(response.body).to include('Genre: Pop')
    end
  end

  context "GET /artists/new" do
    it "returns 200 OK" do
      response = get('/artists/new')

      expect(response.status).to eq(200)
      expect(response.body).to include("<form method = 'POST' action = '/artists'>")
      expect(response.body).to include("<h1>Add an artist</h1>")
      expect(response.body).to include("<input type = 'text' name = 'name'>")
      expect(response.body).to include("<input type = 'text' name = 'genre'>")
      expect(response.body).to include("<input type = 'submit' value = 'Submit'>")
    end
  end

  context "POST /artists" do
    it 'creates an artist and returns confirmation screen' do
      response = post('/artists', name: "Giveon", genre: "RnB")

      expect(response.status).to eq(200)
      expect(response.body).to include('You added the artist: Giveon')
      response = get('/artists')

      expect(response.status).to eq(200)
      expect(response.body).to include 'Giveon'
    end

    it 'creates an artist and returns confirmation screen with a different artist' do
      response = post('/artists', name: "Oasis", genre: "rock")

      expect(response.status).to eq(200)
      expect(response.body).to include('You added the artist: Oasis')
      response = get('/artists')

      expect(response.status).to eq(200)
      expect(response.body).to include 'Oasis'
    end

    it "returns 400 if input is invalid" do
      response = post('/artists', invalid_name: 'Giveon')

      expect(response.status).to eq(400)
    end
  end
end