class HookController < ApplicationController
  def create
    if sound = Sound.find_by(name: params[:provider])
      ActionCable.server.broadcast 'messages',
        message: "Soundhook received for #{params[:provider]}",
        sound_url: sound.sound_file.url,
        format: sound.sound_file_content_type
      render plain: "Soundhook received for #{params[:provider]}"
    else
      head :not_found
    end
  end
end
