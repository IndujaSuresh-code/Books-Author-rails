require Rails.root.join("app", "representers", "books_representer")
module Api
  module V1
    class BooksController < ApplicationController
      rescue_from ActiveRecord::RecordNotDestroyed, with: :not_destroyed
      rescue_from ActiveRecord::RecordNotFound, with: :not_found

      before_action :authenticate_user, only: [:create , :destroy]
      def index
        page = params.fetch(:page, 1).to_i
        per_page = params.fetch(:per_page, 10).to_i

        offset = (page - 1) * per_page
        books = Book.includes(:author).limit(per_page).offset(offset)

        render json: BooksRepresenter.new(books).to_json
      end
      def create
        author = if params[:author].present?
                  Author.create!(author_params)
                else
                  Author.find(params[:book][:author_id])
                end

        book = Book.new(book_params.merge(author_id: author.id))

        if book.save
          render json: book, status: :created
        else
          render json: book.errors, status: :unprocessable_entity
        end
      end


      def destroy
        book = Book.find(params[:id])
        book.destroy!
        head :no_content
      end

      private
      def authenticate_user
        header = request.headers['Authorization']
        header = header.split(' ').last if header.present?

        begin
          decoded = JWT.decode(header, AuthenticationTokenService::HMAC_SECRET, true, algorithm: AuthenticationTokenService::ALG_TYPE)
          @current_user_id = decoded[0]['user_id']
        rescue JWT::DecodeError
          render json: { error: 'Unauthorized' }, status: :unauthorized
        end
      end

      def author_params
        params.require(:author).permit(:first_name, :last_name, :age) if params[:author]
      end


      def book_params
        params.require(:book).permit(:title)
      end

      def not_destroyed
        render json: { error: "Cannot delete book. It has been borrowed." }, status: :unprocessable_entity
      end
      def not_found
        render json: { error: "Book not found." }, status: :not_found
      end
    end
  end
end
