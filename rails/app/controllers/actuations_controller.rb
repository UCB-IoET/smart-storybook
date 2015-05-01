class ActuationsController < ApplicationController
  before_action :set_actuation, only: [:show, :edit, :update, :destroy]

  # GET /actuations
  # GET /actuations.json
  def index
    @actuations = Actuation.all
  end

  # GET /actuations/1
  # GET /actuations/1.json
  def show
  end

  # GET /actuations/new
  def new
    @actuation = Actuation.new
  end

  # GET /actuations/1/edit
  def edit
  end

  # POST /actuations
  # POST /actuations.json
  def create
    @actuation = Actuation.new(actuation_params)

    respond_to do |format|
      if @actuation.save
        format.html { redirect_to @actuation, notice: 'Actuation was successfully created.' }
        format.json { render action: 'show', status: :created, location: @actuation }
      else
        format.html { render action: 'new' }
        format.json { render json: @actuation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /actuations/1
  # PATCH/PUT /actuations/1.json
  def update
    respond_to do |format|
      if @actuation.update(actuation_params)
        format.html { redirect_to @actuation, notice: 'Actuation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @actuation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /actuations/1
  # DELETE /actuations/1.json
  def destroy
    @actuation.destroy
    respond_to do |format|
      format.html { redirect_to actuations_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_actuation
      @actuation = Actuation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def actuation_params
      params.require(:actuation).permit(:behavior_id, :actuator_id)
    end
end
