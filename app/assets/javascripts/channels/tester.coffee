#= require cable
#= require_self
#= require_tree .

this.App = {}


tag = document.createElement('script')
tag.src = 'https://www.youtube.com/iframe_api'
firstScriptTag = document.getElementsByTagName('script')[0]
firstScriptTag.parentNode.insertBefore tag, firstScriptTag

App.cable = ActionCable.createConsumer()

App.messages = App.cable.subscriptions.create 'MessagesChannel',
  done: true
  received: (data) ->
    @stopEverything()
    switch data.type
      when 'sound'                    then @playSound(data)
      when 'youtube'                  then @playYoutube(data)
      # when 'message'                then @displayMessage(data)
      # when 'sale'                   then @displaySale(data)
      # when 'git_master_modified'    then @gitMasterModified(data)

  stopEverything: ->
    @stopVideo()
    @stopSound()

  playSound: (data) ->
    src = $("#player")
    src.attr 'src', data.sound_url
    src.attr 'type', data.format
    src.trigger('load')
    src.trigger('play')
  stopSound: ->
    src = $("#player")
    src.trigger('pause')

  playYoutube: (data) ->
    if @player?
      @player.loadVideoById(data.url, 0, "large")
    else
      @player = new (YT.Player)('youtube_player',
        videoId: data.url
        playerVars:
          controls: 0
          showinfo: 0
          rel: 0
        events:
          'onReady': @onPlayerReady.bind(this)
          'onStateChange': @onPlayerStateChange.bind(this))
    return

  onPlayerReady: (event) ->
    event.target.playVideo()
    @done = false
    return

  onPlayerStateChange: (event) ->
    if event.data == YT.PlayerState.PLAYING and !@done
      setTimeout @stopVideo.bind(this), 30000
      @done = true
    return

  stopVideo: ->
    return true unless @player?
    @player.stopVideo()
    @player.destroy()
    @player = undefined
    return
