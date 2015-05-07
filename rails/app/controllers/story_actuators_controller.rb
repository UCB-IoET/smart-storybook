class StoryActuatorsController < ApplicationController
  before_action :set_story_actuator, only: [:show, :edit, :update, :destroy]

  # GET /story_actuators
  # GET /story_actuators.json
  def index
    @story_actuators = StoryActuator.all
  end

  # GET /story_actuators/1
  # GET /story_actuators/1.json
  def show
  end

  # GET /story_actuators/new
  def new
    @story_actuator = StoryActuator.new
  end

  # GET /story_actuators/1/edit
  def edit
  end

  # POST /story_actuators
  # POST /story_actuators.json
  def create
    @story_actuator = StoryActuator.new(story_actuator_params)

    respond_to do |format|
      if @story_actuator.save
        format.html { redirect_to @story_actuator, notice: 'Story actuator was successfully created.' }
        format.json { render action: 'show', status: :created, location: @story_actuator }
      else
        format.html { render action: 'new' }
        format.json { render json: @story_actuator.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /story_actuators/1
  # PATCH/PUT /story_actuators/1.json
  def update
    respond_to do |format|
      if @story_actuator.update(story_actuator_params)
        format.html { redirect_to @story_actuator, notice: 'Story actuator was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @story_actuator.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /story_actuators/1
  # DELETE /story_actuators/1.json
  def destroy
    @story_actuator.destroy
    respond_to do |format|
      format.html { redirect_to story_actuators_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_story_actuator
      @story_actuator = StoryActuator.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def story_actuator_params
      params.require(:story_actuator).permit(:uuid, :state, :story_page_id)
    end
end
