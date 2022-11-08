class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
      render json: items, except: [:created_at, :updated_at]
    else
      items = Item.all
      render json: items, except: [:created_at, :updated_at], include: :user
    end
  end

  def show
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items.find(params[:id])
      
    else
      items = Item.find(params[:id])
    end
    render json: items , except: [:created_at, :updated_at]
  end

  def create
    if params[:user_id]
      user = User.find(params[:user_id])
      new_item = Item.create(item_params)
    end
    render json: new_item, except: [:created_at, :updated_at], status: :created
  end

  private

  def render_not_found_response
    render json: { error: "Dog house not found" }, status: :not_found
  end
  
  def item_params
    params.permit(:name, :description, :price, :user_id)
  end


end
