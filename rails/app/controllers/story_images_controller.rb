class StoryImagesController < ApplicationController
  before_action :set_story_image, only: [:show, :edit, :update, :destroy]

  # GET /story_images
  # GET /story_images.json
  def index
    @story_images = StoryImage.all
  end

  # GET /story_images/1
  # GET /story_images/1.json
  def show
  end

  # GET /story_images/new
  def new
    @story_image = StoryImage.new
  end

  # GET /story_images/1/edit
  def edit
  end

  # POST /story_images
  # POST /story_images.json
  def create
    @story_image = StoryImage.new(story_image_params)

    respond_to do |format|
      if @story_image.save
        format.html { redirect_to @story_image, notice: 'Story image was successfully created.' }
        format.json { render action: 'show', status: :created, location: @story_image }
      else
        format.html { render action: 'new' }
        format.json { render json: @story_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /story_images/1
  # PATCH/PUT /story_images/1.json
  def update
    respond_to do |format|
      if @story_image.update(story_image_params)
        format.html { redirect_to @story_image, notice: 'Story image was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @story_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /story_images/1
  # DELETE /story_images/1.json
  def destroy
    @story_image.destroy
    respond_to do |format|
      format.html { redirect_to story_images_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_story_image
      @story_image = StoryImage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def story_image_params
      params.require(:story_image).permit(:file, :size, :story_page_id)
    end
end
