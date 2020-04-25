class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    admin_artworks_path
  end

  def default_fallback_location
    root_path
  end

  def default_redirect_back(options = {})
    redirect_back options.merge(fallback_location: default_fallback_location)
  end
end
