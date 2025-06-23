require "test_helper"

class BookTest < ActiveSupport::TestCase
  test "is valid with required attributes" do
    b = Book.create(title: "The Great Gatsby", author: "F. Scott Fitzgerald")
    assert b.valid?
  end
end
