class Admin::RestaurantsController < Admin::BaseController
  
  before_action :set_restaurant, only:[:show, :edit, :update, :destroy]
  def index
    @restaurants = Restaurant.page(params[:page]).per(10)
  end

  def new
    @restaurant = Restaurant.new   
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    if @restaurant.save
      flash[:notice] = "新增餐廳成功！"
      redirect_to admin_restaurants_path
    else
      flash.now[:alert] = "新增失敗！請填入完整資料！"
      render :new
    end
  end

  def update
    if @restaurant.update(restaurant_params)
      flash[:notice] = "修改資料成功"
      redirect_to admin_restaurants_path
    else
      flash.now[:alert] = "更新資料失敗!"
      render :edit  
    end
  end

  def destroy
    @restaurant.destroy
    redirect_to admin_restaurants_path
    flash[:alert] = "restaurant was deleted"
  end




  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:id]) 
  end


  def restaurant_params
    params.require(:restaurant).permit(:name, :tel, :address, :opening_hours, :description, :image, :category_id)
    
  end

end
