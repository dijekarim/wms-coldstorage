class ApplicationController < ActionController::Base
  include Pundit::Authorization
  before_action :authenticate_user!
  rescue_from Pundit::NotAuthorizedError, with: :forbidden

  private

  def forbidden
    render json: { error: "Not authorized" }, status: :forbidden
  end
end
