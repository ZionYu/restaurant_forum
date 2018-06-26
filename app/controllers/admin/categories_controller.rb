class Admin::CategoriesController < ApplicationController
  before_action :authenticate_admin
  before_action :set_category, :only => [:update, :destroy]

  def index
    @categories = Category.all
    if params[:id]
      set_category
    else 
      @category = Category.new
    end
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:notice] = "新增了一個分類"
      redirect_to admin_categories_path
    else
      @categories = Category.all
      render :index
    end

  end

  def update
    
    if @category.update(category_params)
      flash[:notice] = "更新成功"
      redirect_to admin_categories_path
    else
      @category = Category.all
      render :index

    end

  end

  def destroy
    
    @category.destroy
    flash[:notice] = "category was succcessfully deleted"
    redirect_to admin_categories_path
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end
  def category_params
    params.require(:category).permit(:name)
    
  end
end
