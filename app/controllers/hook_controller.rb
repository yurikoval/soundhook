require 'uri'
class HookController < ApplicationController
  after_action :send_sound, only: :create
  skip_before_action :verify_authenticity_token

  def create
    if webhook = Sound.find_by(name: params[:provider])
      formatter = "#{webhook.hook_type.camelize}Formatter"
        .safe_constantize
        .new(webhook, request)
      @data = formatter.data
      render inline: formatter.response, format: formatter.format
    else
      head :not_found
    end
  end

  def refresh
    ActionCable.server.broadcast 'messages', {type: 'refresh'}
    head :ok
  end

private

  def send_sound
    if @data
      ActionCable.server.broadcast 'messages', @data
    end
  end
end
