class TesterController < ApplicationController
  if ENV['AUTH_USER'] && ENV['AUTH_PASS']
    http_basic_authenticate_with name: ENV['AUTH_USER'], password: ENV['AUTH_PASS']
  end

  def index
  end
end
