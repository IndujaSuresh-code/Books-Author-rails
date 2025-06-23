module Api
  module V1
    class AuthenticationController < ApplicationController
      def create
        return render json: { error: 'Missing password' }, status: :unprocessable_entity unless params[:password].present?

        user = User.find_by(username: params[:username])

        if user && user.authenticate(params[:password])
          token = AuthenticationTokenService.call(user.id)
          render json: { token: token }, status: :ok
        else
          render json: { error: 'Invalid username or password' }, status: :unauthorized
        end
      end
    end
  end
end
