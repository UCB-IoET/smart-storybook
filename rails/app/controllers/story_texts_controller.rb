class StoryTextsController < ApplicationController
  before_action :set_story_text, only: [:show, :edit, :update, :destroy]

  # GET /story_texts
  # GET /story_texts.json
  def index
    @story_texts = StoryText.all
  end



  # GET /story_texts/1
  # GET /story_texts/1.json
  def show
  end

  # GET /story_texts/new
  def new
    @story_text = StoryText.new
  end

  # GET /story_texts/1/edit
  def edit
  end

  # POST /story_texts
  # POST /story_texts.json
  def create
    @story_text = StoryText.new(story_text_params)

    respond_to do |format|
      if @story_text.save
        format.html { redirect_to @story_text, notice: 'Story text was successfully created.' }
        format.json { render action: 'show', status: :created, location: @story_text }
      else
        format.html { render action: 'new' }
        format.json { render json: @story_text.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /story_texts/1
  # PATCH/PUT /story_texts/1.json
  def update
    respond_to do |format|
      if @story_text.update(story_text_params)
        format.html { redirect_to @story_text, notice: 'Story text was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @story_text.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /story_texts/1
  # DELETE /story_texts/1.json
  def destroy
    @story_text.destroy
    respond_to do |format|
      format.html { redirect_to story_texts_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_story_text
      @story_text = StoryText.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def story_text_params
      params.require(:story_text).permit(:text, :fontSize, :center, :textBackgroundHex, :textBackgroundAlpha, :border, :story_page_id)
    end
end
