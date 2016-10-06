require 'uri'
class HookController < ApplicationController
  after_action :send_sound
  skip_before_action :verify_authenticity_token

  def create
    if sound = Sound.find_by(name: params[:provider])
      formatter = "#{sound.hook_type.camelize}Formatter"
        .safe_constantize
        .new(sound, params)
      @data = formatter.data
      render inline: formatter.response, format: formatter.format
    else
      head :not_found
    end
  end

private

  def send_sound
    if @data
      ActionCable.server.broadcast 'messages', @data
    end
  end
end
