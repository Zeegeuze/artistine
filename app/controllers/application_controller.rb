class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    admin_artworks_path
  end
end
