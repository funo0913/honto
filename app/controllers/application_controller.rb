class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # @logger = Logger.new('./webapi.log')
end
