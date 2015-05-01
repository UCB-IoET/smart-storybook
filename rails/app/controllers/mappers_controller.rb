class MappersController < ApplicationController
  before_action :set_mapper, only: [:show, :edit, :update, :destroy]

  # GET /mappers
  # GET /mappers.json
  def index
    @mappers = Mapper.all
  end

  # GET /mappers/1
  # GET /mappers/1.json
  def show
  end

  # GET /mappers/new
  def new
    @mapper = Mapper.new
  end

  # GET /mappers/1/edit
  def edit
  end

  # POST /mappers
  # POST /mappers.json
  def create
    @mapper = Mapper.new(mapper_params)

    respond_to do |format|
      if @mapper.save
        format.html { redirect_to @mapper, notice: 'Mapper was successfully created.' }
        format.json { render action: 'show', status: :created, location: @mapper }
      else
        format.html { render action: 'new' }
        format.json { render json: @mapper.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mappers/1
  # PATCH/PUT /mappers/1.json
  def update
    respond_to do |format|
      if @mapper.update(mapper_params)
        format.html { redirect_to @mapper, notice: 'Mapper was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @mapper.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mappers/1
  # DELETE /mappers/1.json
  def destroy
    @mapper.destroy
    respond_to do |format|
      format.html { redirect_to mappers_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mapper
      @mapper = Mapper.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mapper_params
      params[:mapper]
    end
end
