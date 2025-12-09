class HomeController < ApplicationController
  def index
  end

  def search
    unless user_signed_in?
      redirect_to login_selector_path and return
    end
  end
end
