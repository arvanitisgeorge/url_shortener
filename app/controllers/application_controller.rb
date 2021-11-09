class ApplicationController < ActionController::Base
  before_action :initializeDefaultProviders

  def initializeDefaultProviders
    UrlProvider.find_or_create_by(name: 'bit.ly')
    UrlProvider.find_or_create_by(name: 'tinyurl.com')
  end
end
