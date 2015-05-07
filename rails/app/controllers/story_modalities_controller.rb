class StoryModalitiesController < ApplicationController
  before_action :set_story_modality, only: [:show, :edit, :update, :destroy]

  # GET /story_modalities
  # GET /story_modalities.json
  def index
    @story_modalities = StoryModality.all
  end

  # GET /story_modalities/1
  # GET /story_modalities/1.json
  def show
  end

  # GET /story_modalities/new
  def new
    @story_modality = StoryModality.new
  end

  # GET /story_modalities/1/edit
  def edit
  end

  
  # POST /story_modalities
  # POST /story_modalities.json
  def create
    @story_modality = StoryModality.new(story_modality_params)

    respond_to do |format|
      if @story_modality.save
        format.html { redirect_to @story_modality, notice: 'Story modality was successfully created.' }
        format.json { render action: 'show', status: :created, location: @story_modality }
      else
        format.html { render action: 'new' }
        format.json { render json: @story_modality.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /story_modalities/1
  # PATCH/PUT /story_modalities/1.json
  def update
    respond_to do |format|
      if @story_modality.update(story_modality_params)
        format.html { redirect_to @story_modality, notice: 'Story modality was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @story_modality.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /story_modalities/1
  # DELETE /story_modalities/1.json
  def destroy
    @story_modality.destroy
    respond_to do |format|
      format.html { redirect_to story_modalities_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_story_modality
      @story_modality = StoryModality.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def story_modality_params
      params.require(:story_modality).permit(:actuator_id, :strength, :story_id, :story_page_id)
    end
end
