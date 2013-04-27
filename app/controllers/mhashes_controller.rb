class MhashesController < ApplicationController
  # GET /mhashes
  # GET /mhashes.json
  def index
    if current_user
      @mhashes = Mhash.where(:user_id => current_user.id).all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @mhashes }
    end
  end

  # GET /mhashes/1
  # GET /mhashes/1.json
  def show
    if current_user
      @mhash = Mhash.where(:user_id => current_user.id).find(params[:id]).first
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @mhash }
    end
  end

  # GET /mhashes/new
  # GET /mhashes/new.json
  def new
    if current_user
      @mhash = Mhash.new
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @mhash }
    end
  end

  # GET /mhashes/1/edit
  def edit
    @mhash = Mhash.find(params[:id])
  end

  # POST /mhashes
  # POST /mhashes.json
  def create
    if current_user
      @mhash = Mhash.new
      @mhash.data = params[:data]
      current_user.mhashes << @mhash
    end

    respond_to do |format|
      if @mhash.save
        format.html { redirect_to @mhash, notice: 'Mhash was successfully created.' }
        format.json { render json: @mhash, status: :created, location: @mhash }
      else
        format.html { render action: "new" }
        format.json { render json: @mhash.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /mhashes/1
  # PUT /mhashes/1.json
  def update
    @mhash = Mhash.find(params[:id])

    respond_to do |format|
      if @mhash.update_attributes(params[:mhash])
        format.html { redirect_to @mhash, notice: 'Mhash was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @mhash.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mhashes/1
  # DELETE /mhashes/1.json
  def destroy
    @mhash = Mhash.find(params[:id])
    @mhash.destroy

    respond_to do |format|
      format.html { redirect_to mhashes_url }
      format.json { head :no_content }
    end
  end
end
