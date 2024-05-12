class DashboardController < ApplicationController
  before_action :authenticate_user!
  layout 'authenticated'
  def index
    # You can add a logger here to ensure this action is being called
    Rails.logger.debug "Dashboard index is being rendered"
  end
end
