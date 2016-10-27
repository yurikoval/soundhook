require 'digest/md5'
require 'giphy'
class HerokuFormatter < BaseFormatter
  DEPLOY_KEYWORDS = %w(success rocket rocket-launch).freeze
  def data
    hash = Digest::MD5.hexdigest(@params[:user].downcase)
    image = Giphy.random(DEPLOY_KEYWORDS.sample)
    image_url = image.image_original_url.to_s
    {
      type: 'heroku',
      image_url: image_url,
      repository: @params[:app],
      sender_name: @params[:user],
      sender_img: "https://www.gravatar.com/avatar/#{hash}",
      commits: @params[:git_log].split("\n"),
      sound_url: @webhook.sound_file.url,
      format: @webhook.sound_file_content_type
    }
  end
end
