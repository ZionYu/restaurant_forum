class RestaurantsController < ApplicationController
  before_action :authenticate_user! 
  def index
   @restaurants = Restaurant.page(params[:page]).per(9)
   @categories = Category.all 
  end

  def show
    @restaurant = Restaurant.find(params[:id])
    @comment = Comment.new 
  end

  def feeds
    @recent_restaurants = Restaurant.all.order(created_at: :desc).limit(10)
    @recent_comments = Comment.all.order(created_at: :desc).limit(10)
  end

  def ranking
    @top10_restaurants = Restaurant.all.order(favorites_count: :desc).limit(10)
  end

  def dashboard
    @restaurant = Restaurant.find(params[:id])
  end

  def favorite
    @restaurant = Restaurant.find(params[:id])
    @restaurant.favorites.create!(user: current_user)
    redirect_back(fallback_location: root_path)
  end

  def unfavorite
    @restaurant = Restaurant.find(params[:id])
    favorites = Favorite.where(restaurant: @restaurant, user: current_user)
    favorites.destroy_all
    redirect_back(fallback_location: root_path)
  end

  def like
    @restaurant = Restaurant.find(params[:id])
    @restaurant.likes.create!(user: current_user)
    redirect_back(fallback_location: root_path)   
  end

  def unlike
    @restaurant = Restaurant.find(params[:id])
    likes = Like.where(restaurant: @restaurant, user: current_user)
    likes.destroy_all
    redirect_back(fallback_location: root_path)
  end

  def analytics
    analytics = Google::Apis::AnalyticsreportingV4::AnalyticsReportingService.new
    analytics.authorization = current_user.token # See: https://github.com/zquestz/omniauth-google-oauth2

    date_range = Google::Apis::AnalyticsreportingV4::DateRange.new(start_date: '7DaysAgo', end_date: 'today')
    metric = Google::Apis::AnalyticsreportingV4::Metric.new(expression: 'ga:sessions', alias: 'sessions')
    dimension = Google::Apis::AnalyticsreportingV4::Dimension.new(name: 'ga:browser')

    request = Google::Apis::AnalyticsreportingV4::GetReportsRequest.new(
      report_requests: [Google::Apis::AnalyticsreportingV4::ReportRequest.new(
      view_id: '180578182',
      metrics: [metric],
      dimensions: [dimension],
      date_ranges: [date_range]
      )]
    ) # thanks to @9mm: https://github.com/google/google-api-ruby-client/issues/489

    response = analytics.batch_get_reports(request)
    response.reports
    
  end
  
end
