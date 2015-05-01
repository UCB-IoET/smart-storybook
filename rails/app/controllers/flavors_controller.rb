class FlavorsController < ApplicationController
  before_action :set_flavor, only: [:show, :edit, :update, :destroy]

  # GET /flavors
  # GET /flavors.json
  def index
    @flavors = Flavor.all
  end

  # GET /flavors/1
  # GET /flavors/1.json
  def show
    @behaviors = Behavior.all
    @flavor = Flavor.find(params[:id])
    h = @flavor.attributes
    h["k"] = 1000.0 / (1000.0 ** (1.0 / @flavor.alpha))
    respond_to do |format|
       format.html
       format.json { render json:  h}
    end
  end

  # GET /flavors/1/behaviors
  # GET /flavors/1/behaviors.json
  def behaviors
     flavor = Flavor.find(params[:id]);
     # clean_behaviors = flavor.behaviors.collect{|a| {name: a.name.humanize, id: a.id}}
     clean_behaviors = flavor.behaviors

     respond_to do |format|
       format.html { render json: clean_behaviors }
       format.json { render json: clean_behaviors }
     end
  end
  def tags
     tags = Flavor.find(params[:id]).tags
     respond_to do |format|
       format.html { render json: tags }
       format.json { render json: tags }
     end
  end

  # GET /flavors/1/behaviors
  # GET /flavors/1/behaviors.json
  def counts
     counts = Flavor.counts
     respond_to do |format|
       format.html { render json: counts }
       format.json { render json: counts }
     end
  end

  # GET /flavors/new
  def new
    @flavor = Flavor.new
  end

  # GET /flavors/1/edit
  def edit
    @behaviors = Behavior.all
  end

  # POST /flavors
  # POST /flavors.json
  def create
    @flavor = Flavor.new(flavor_params)

    respond_to do |format|
      if @flavor.save
        format.html { redirect_to @flavor, notice: 'Flavor was successfully created.' }
        format.json { render action: 'show', status: :created, location: @flavor }
      else
        format.html { render action: 'new' }
        format.json { render json: @flavor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /flavors/1
  # PATCH/PUT /flavors/1.json
  def update
    respond_to do |format|
      if @flavor.update(flavor_params)
        format.html { redirect_to @flavor, notice: 'Flavor was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @flavor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /flavors/1
  # DELETE /flavors/1.json
  def destroy
    @flavor.destroy
    respond_to do |format|
      format.html { redirect_to flavors_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_flavor
      @flavor = Flavor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def flavor_params
      params.require(:flavor).permit(:alpha, :name, :img, :actuator_id)
    end
end
