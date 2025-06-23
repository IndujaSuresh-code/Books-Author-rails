require 'rails_helper'

RSpec.describe Author, type: :model do
  it "is valid with valid attributes" do
    author = Author.new(first_name: "Induja", last_name: "S", age: 30)
    expect(author).to be_valid
  end
end
