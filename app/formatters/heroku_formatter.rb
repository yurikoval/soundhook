require 'digest/md5'
class HerokuFormatter < BaseFormatter
  def data
    hash = Digest::MD5.hexdigest(@params[:user].downcase)
    {
      type: 'heroku',
      repository: @params[:app],
      sender_name: @params[:user],
      sender_img: "https://www.gravatar.com/avatar/#{hash}",
      commits: @params[:git_log].split("\n"),
      sound_url: @webhook.sound_file.url,
      format: @webhook.sound_file_content_type
    }
  end
end
