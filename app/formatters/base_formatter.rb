class BaseFormatter
  FORMATTERS = %w(sound youtube zuora message github heroku).freeze
  def initialize(webhook, request = {})
    @webhook = webhook
    @request = request
    @params = @request.params
  end

  def response
    "Sent #{@params[:provider]} to Billboard"
  end

  def format
    :plain
  end
end
