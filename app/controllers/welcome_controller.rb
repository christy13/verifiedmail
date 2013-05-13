class WelcomeController < ApplicationController

  def index
    current_user = true
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
    current_user = true
    if current_user
      respond_to do |format|
        format.html
      end
    else
      redirect_to :login
    end
  end

  def verify
    current_user = true
    if current_user
      respond_to do |format|
        format.html
      end
    else
      redirect_to :login
    end
  end

  def about
    current_user = true
    if current_user
      respond_to do |format|
        format.html
      end
    else
      redirect_to :login
    end
  end
end