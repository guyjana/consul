class DebatesController < ApplicationController
  before_action :set_debate, only: [:show, :edit, :update]
  before_action :authenticate_user!, except: [:show, :index]
  before_action :validate_ownership, only: [:edit, :update]

  def index
    if params[:tag]
      @debates = Debate.tagged_with(params[:tag])
    else
      @debates = Debate.all
    end
  end

  def show
  end

  def new
    @debate = Debate.new
  end

  def edit
  end

  def create
    @debate = Debate.new(debate_params)
    @debate.author = current_user
    @debate.save
    respond_with @debate
  end

  def update
    @debate.update(debate_params)
    respond_with @debate
  end


  private
    def set_debate
      @debate = Debate.find(params[:id])
    end

    def debate_params
      params.require(:debate).permit(:title, :description, :tag_list, :terms_of_service)
    end

    def validate_ownership
      raise ActiveRecord::RecordNotFound unless @debate.editable_by?(current_user)
    end

end