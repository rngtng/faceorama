class ApplicationController < ActionController::Base
  include KoalaHelper
  include AuthenticatedSystem

  protect_from_forgery

end
