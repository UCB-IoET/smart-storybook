class ActuatorsController < ApplicationController
  before_action :set_actuator, only: [:show, :edit, :update, :destroy]

  # GET /actuators
  # GET /actuators.json
  def index
    @actuators = Actuator.all
    clean_actuators = @actuators.collect{|a| {name: a.name.humanize, id: a.id, picture: a.picture_url}}

    respond_to do |format|
      format.html
      format.json { render json: clean_actuators}
    end
  end

  # GET /actuators/1
  # GET /actuators/1.json
  def show
  end
  
  # GET /actuators/flavors/1
  # GET /actuators/flavors/1.json
  def flavors
    actuator = Actuator.find(params[:id])
    respond_to do |format|
      format.html { render json: actuator.flavors}
      format.json { render json: actuator.flavors}
    end
  end

  # GET /actuators/counts
  # GET /actuators/counts.json
  def counts
    counts = Actuator.counts
    respond_to do |format|
      format.html { render json: counts}
      format.json { render json: counts}
    end
  end
  # GET /actuators/new
  def new
    @actuator = Actuator.new
    @flavors = Flavor.all
  end

  # GET /actuators/1/edit
  def edit
    @flavors = Flavor.all
  end

  # POST /actuators
  # POST /actuators.json
  def create
    actuator_params["name"] = dehumanize actuator_params["name"]
    @actuator = Actuator.new(actuator_params)
    update_flavors

    respond_to do |format|
      if @actuator.save
        format.html { redirect_to @actuator, notice: 'Actuator was successfully created.' }
        format.json { render action: 'show', status: :created, location: @actuator }
      else
        format.html { render action: 'new' }
        format.json { render json: @actuator.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /actuators/1
  # PATCH/PUT /actuators/1.json
  def update
    update_flavors
    respond_to do |format|
      if @actuator.update(actuator_params)
        format.html { redirect_to @actuator, notice: 'Actuator was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @actuator.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /actuators/1
  # DELETE /actuators/1.json
  def destroy
    @actuator.destroy
    respond_to do |format|
      format.html { redirect_to actuators_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_actuator
      @actuator = Actuator.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def actuator_params
      params.require(:actuator).permit(:name, :flavor_id, :picture)
    end

    def update_flavors
      flavor_ids = params["flavor_ids"]
      if flavor_ids
        flavor_ids.each do |id|
          Flavor.find(id).update(actuator_id: @actuator.id)
        end
      end
    end
end
