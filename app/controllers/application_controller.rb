# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_with_wrong_role

  private

  def user_with_wrong_role
    flash[:alert] = 'You have the wrong role to perform this action'
    redirect_back(fallback_location: root_path)
  end
end
