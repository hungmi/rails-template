# TODO 設定 credentials fb_app_id, fb_app_secret

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, Rails.application.credentials.dig(:fb_app_id), Rails.application.credentials.dig(:fb_app_secret),
    scope: 'public_profile,email', info_fields: 'email,first_name,last_name', secure_image_url: true, image_size: 'large',
    client_options: {
      site: 'https://graph.facebook.com/v8.0',
      authorize_url: "https://www.facebook.com/v8.0/dialog/oauth"
    }
end

# fix deprecation, check https://edgeguides.rubyonrails.org/autoloading_and_reloading_constants.html#autoloading-when-the-application-boots
Rails.application.reloader.to_prepare do
	OmniAuth.config.on_failure = Facebook::UsersController.action(:oauth_failure)
end