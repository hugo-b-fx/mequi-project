class HomeController < ApplicationController
  def index
    @coaches = Coach.includes(:user).limit(6)
  end

  def search
    unless user_signed_in?
      redirect_to login_selector_path and return
    end
  end
end
