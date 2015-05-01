class StoryPagesController < ApplicationController
  before_action :set_story_page, only: [:show, :edit, :update, :destroy]

  # GET /story_pages
  # GET /story_pages.json
  def index
    @story_pages = StoryPage.all
  end

  # GET /story_pages/1
  # GET /story_pages/1.json
  def show
  end

  # GET /story_pages/new
  def new
    @story_page = StoryPage.new
  end

  # GET /story_pages/1/edit
  def edit
  end

  # POST /story_pages
  # POST /story_pages.json
  def create
    @story_page = StoryPage.new(story_page_params)

    respond_to do |format|
      if @story_page.save
        format.html { redirect_to @story_page, notice: 'Story page was successfully created.' }
        format.json { render action: 'show', status: :created, location: @story_page }
      else
        format.html { render action: 'new' }
        format.json { render json: @story_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /story_pages/1
  # PATCH/PUT /story_pages/1.json
  def update
    respond_to do |format|
      if @story_page.update(story_page_params)
        format.html { redirect_to @story_page, notice: 'Story page was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @story_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /story_pages/1
  # DELETE /story_pages/1.json
  def destroy
    @story_page.destroy
    respond_to do |format|
      format.html { redirect_to story_pages_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_story_page
      @story_page = StoryPage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def story_page_params
      params.require(:story_page).permit(:story_id, :storytype, :page_number)
    end
end
