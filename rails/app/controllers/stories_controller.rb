class StoriesController < ApplicationController
  before_action :set_story, only: [:show, :edit, :update, :destroy]

  def ipad_output
    story = Story.find(params[:id])
    output = {story: story.story_pages.map{|s|
      {
        type: s.storytype, 
        text_labels: s.story_texts.map{|st| {
            text: st.text, 
            fontSize: st.fontSize, 
            center: JSON.parse(st.center),
            textBackgroundHex: st.textBackgroundHex, 
            textBackgroundAlpha: st.textBackgroundAlpha,
            border: st.border 
          }
        },
        image_labels: s.story_images.map{|st| {
            imageURL: st.file_url, 
            imageSize: JSON.parse(st.size)
          }
        }, 
        actuator_labels: [{
                            UUID: "3c10b74e-f027-11e4-90ec-1681e6b88ec1", 
                            actuator_type: "SVCD", 
                            metadata: {
                              modality: "light", 
                              action: "turn_on"
                            }
                          }]
        }
      }
    }

    render :json => output
  end
  # GET /stories
  # GET /stories.json
  def index
    @stories = Story.all
  end

  # GET /stories/1
  # GET /stories/1.json
  def show
  end

  # GET /stories/new
  def new
    @story = Story.new
  end

  # GET /stories/1/edit
  def edit
  end

  # POST /stories
  # POST /stories.json
  def create
    @story = Story.new(story_params)

    respond_to do |format|
      if @story.save
        format.html { redirect_to @story, notice: 'Story was successfully created.' }
        format.json { render action: 'show', status: :created, location: @story }
      else
        format.html { render action: 'new' }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stories/1
  # PATCH/PUT /stories/1.json
  def update
    respond_to do |format|
      if @story.update(story_params)
        format.html { redirect_to @story, notice: 'Story was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stories/1
  # DELETE /stories/1.json
  def destroy
    @story.destroy
    respond_to do |format|
      format.html { redirect_to stories_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_story
      @story = Story.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def story_params
      params.require(:story).permit(:title, :author)
    end
end
