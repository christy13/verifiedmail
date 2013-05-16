class WelcomeController < ApplicationController
  

  def index
    if current_user
      respond_to do |format|
        format.html
      end
    else
      redirect_to :login
    end
  end

  def login
    respond_to do |format|
      format.html
    end
  end

  def sign
    if current_user
      respond_to do |format|
        format.html
      end
    else
      redirect_to :login
    end
  end

  def verify
    if current_user
      respond_to do |format|
        format.html
      end
    else
      redirect_to :login
    end
  end

  def about
    if current_user
      respond_to do |format|
        format.html
      end
    else
      redirect_to :login
    end
  end
end