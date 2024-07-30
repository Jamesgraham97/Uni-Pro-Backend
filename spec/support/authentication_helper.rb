# spec/support/authentication_helper.rb
module AuthenticationHelper
  def authenticated_header(user)
    token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
    { 'Authorization': "Bearer #{token}" }
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelper, type: :request
end
