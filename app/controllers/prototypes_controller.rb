class PrototypesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :update, :destroy]
  
  def index
    @prototypes = Prototype.all
  end

  def new
    @prototype = Prototype.new
  end

  def show
    @prototypes = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototypes.comments.includes(:user)
  end

  def edit
    @prototype = Prototype.find(params[:id])
      unless user_signed_in? && current_user.id == @prototype.user_id
        redirect_to action: :index
      end
  end

  def update
       @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
       redirect_to prototype_path
    else
      render :edit    
    end
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to prototypes_path
    else
      render :new    
    end
  end

  def destroy
    prototype = Prototype.find(params[:id])
    prototype.destroy
    render :index
  end

  private 

  def prototype_params
   params.require(:prototype).permit(:image, :title, :catch_copy, :concept, :comment).merge(user_id: current_user.id)
  end

end

