class YoutubeFormatter < BaseFormatter
  def data
    url = extract_youtube_id(@params[:text])
    {
      type: 'youtube',
      name: @params[:user_name],
      url: url,
    }
  end

private

  def extract_youtube_id(url)
    URI(url).path[1..-1] rescue 'dQw4w9WgXcQ'
  end
end
