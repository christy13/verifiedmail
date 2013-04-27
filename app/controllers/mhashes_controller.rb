class MhashesController < ApplicationController
  # GET /mhashes
  # GET /mhashes.json
  # eventually delete for security reasons
  def index
    if current_user
      @mhashes = Mhash.where(user_id: current_user.id).all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @mhashes }
    end
  end

  # POST /mhashes
  # POST /mhashes.json
  def create
    if current_user
      @mhash = Mhash.new
      @mhash.data = params[:data]
      current_user.mhashes << @mhash
    end

    if @mhash.save
      render json: { success: true, date: @mhash.created_at }, status: :created, location: @mhash
    else
      render json: { success: false, date: null }, status: :unprocessable_entity 
    end
  end

  # DELETE /mhashes/1
  # DELETE /mhashes/1.json
  def destroy
    if current_user
      @mhash = Mhash.where(user_id: current_user.id).find(params[:id])
      @mhash.destroy
    end

    respond_to do |format|
      format.html { redirect_to mhashes_url }
      format.json { head :no_content }
    end
  end

  # Checks if mhash exists
  def verify
    @user = User.where(email: params[:email]).first
    Rails.logger.debug("User: #{@user && @user.email}")
    @mhash = @user && @user.mhashes.where(data: params[:data]).last
    Rails.logger.debug("Mhash: #{@mhash}")
    @check = @mhash != nil
    Rails.logger.debug("Check: #{@check}")
    @date = @check ? @mhash.created_at : nil
    Rails.logger.debug("date: #{@date}")

    render json: { success: @check, date: @date }
  end
end
