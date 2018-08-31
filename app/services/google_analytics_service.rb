require 'google/apis/analytics_v3'

module GoogleAnalyticsService

  def self.authorize(user)
    # refresh and set user access token
    user.refresh_token_if_expired
    access_token = user.access_token

    # create new signet account and authorize
    client = Signet::OAuth2::Client.new(access_token: access_token)
    client.expires_in = Time.now + 1_000_000

    analytics = Google::Apis::AnalyticsV3::AnalyticsService.new
    analytics.authorization = client

    return analytics
  end

end