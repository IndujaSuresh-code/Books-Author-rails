require 'rails_helper'

RSpec.describe "Books API", type: :request do
  def json
    JSON.parse(response.body)
  end

  let!(:user) { create(:user) }
  let!(:token) { AuthenticationTokenService.call(user.id) }
  let!(:headers) { { 'Authorization' => "Bearer #{token}" } }

  describe "GET /api/v1/books" do
    let!(:author) { create(:author, first_name: "Induja", last_name: "S", age: 30) }
    let!(:book)   { create(:book, title: "Sample Book", author: author) }

    it "returns a list of books with correct data" do
      get "/api/v1/books", headers: headers

      expect(response).to have_http_status(:success)
      expect(json.first).to include(
        "id" => book.id,
        "title" => "Sample Book",
        "author_first_name" => "Induja",
        "author_last_name" => "S",
        "author_age" => 30
      )
    end

    it "returns a subset of books based on pagination" do
      create_list(:book, 10, author: author)
      get "/api/v1/books", params: { page: 1, per_page: 5 }, headers: headers

      expect(response).to have_http_status(:success)
      expect(json.length).to eq(5)
    end
  end

  describe "POST /api/v1/books" do
    let!(:author) { create(:author, first_name: "Induja", last_name: "S", age: 30) }

    it "creates a new book" do
      expect {
        post "/api/v1/books", params: {
          book: {
            title: "New Book",
            author_id: author.id
          }
        }, headers: headers
      }.to change { Book.count }.by(1)

      expect(response).to have_http_status(:created).or have_http_status(:success)
    end
  end

  describe "DELETE /api/v1/books/:id" do
    let!(:author) { create(:author, first_name: "Induja", last_name: "S", age: 30) }
    let!(:book)   { create(:book, title: "Delete Me", author: author) }

    it "deletes the book" do
      expect {
        delete "/api/v1/books/#{book.id}", headers: headers
      }.to change { Book.count }.by(-1)

      expect(response).to have_http_status(:no_content).or have_http_status(:success)
    end
  end
end
