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

      expected_response = "Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring"

      expect(response.status).to eq(200)
      expect(response.body).to eq(expected_response)
    end
  end

  context "GET /albums/id" do
    it 'returns 200 OK' do
      response = get('/albums/2')

      expected_response = "Surfer Rosa"

      expect(response.status).to eq(200)
      expect(response.body).to eq(expected_response)
    end
  end

  context "POST /" do
    it 'returns 200 OK' do
      # Assuming the post with id 1 exists.
      response = post('/albums', title: "Voyage", release_year: 2022, artist_id: 2)

      expect(response.status).to eq(200)

      response = get('/albums/13')
      expect(response.status).to eq(200)
      expect(response.body).to eq("Voyage")
    end
  end

  context "GET /artists" do
    it 'returns 200 OK' do
      # Assuming the post with id 1 exists.
      response = get('/artists')
      expected_response = 'Pixies, ABBA, Taylor Swift, Nina Simone, Kiasmos'

      expect(response.status).to eq(200)
      expect(response.body).to eq(expected_response)
    end
  end

  context "POST /artists" do
    it 'returns 200 OK' do
      # Assuming the post with id 1 exists.
      response = post('/artists', name: "Giveon", genre: "RnB")

      expect(response.status).to eq(200)

      response = get('/artists')

      expect(response.status).to eq(200)
      expect(response.body).to eq 'Pixies, ABBA, Taylor Swift, Nina Simone, Kiasmos, Giveon'
    end
  end
end