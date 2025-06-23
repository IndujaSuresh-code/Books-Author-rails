require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_books_url
    assert_response :success
  end
end
