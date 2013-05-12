class RsakeysController < ApplicationController
  # GET /rsakeys
  # GET /rsakeys.json
  def index
    if current_user
      @rsakeys = Rsakey.where(user_id: current_user.id).all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @rsakeys }
    end
  end

  # GET /rsakeys/1
  # GET /rsakeys/1.json
  def show
    if current_user
      @rsakey = Rsakey.where(user_id: current_user.id).first
    end
    if @rsakey
      render json: { public_key: @rsakey.public_key, 
        e_private_key: @rsakey.e_private_key }
    else
      render json: {public_key: "nil", e_private_key: "nil"}
    end
  end

  # GET /rsakeys/new
  # GET /rsakeys/new.json
  def new
    if current_user
      @rsakey = Rsakey.new
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @rsakey }
    end
  end

  # GET /rsakeys/1/edit
  def edit
    if current_user
      #user should only have 1 key
      @rsakey = Rsakey.where(user_id: current_user.id).first
    end
  end

  # POST /rsakeys
  # POST /rsakeys.json
  def create
    if current_user
      @rsakey = Rsakey.new(params[:rsakey])
      @rsakey.public_key = params[:public_key]
      @rsakey.e_private_key = params[:e_private_key]
      current_user.rsakey = @rsakey
    end

    respond_to do |format|
      if @rsakey.save
        render json: {success: true, key: @rsakey}, 
          status: :created, location: @rsakey
      else
        render json: {success: false, key: @rsakey.errors}, 
          status: :unprocessable_entity
      end
    end
  end

  # PUT /rsakeys/1
  # PUT /rsakeys/1.json
  def update
    if current_user
      #user should only have 1 key
      @rsakey = Rsakey.where(user_id: current_user.id).first
    end

    respond_to do |format|
      if @rsakey.update_attributes(params[:rsakey])
        render json: {success: true, key: @rsakey}
      else
        render json: {success: false, key: @rsakey.errors}, 
          status: :unprocessable_entity
      end
    end
  end

  # DELETE /rsakeys/1
  # DELETE /rsakeys/1.json
  def destroy
    if current_user
      #user should only have 1 key
      @rsakey = Rsakey.where(user_id: current_user.id).first
      @rsakey.destroy
    end

    respond_to do |format|
      format.html { redirect_to rsakeys_url }
      format.json { head :no_content }
    end
  end
end
