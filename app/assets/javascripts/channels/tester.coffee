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
      when 'message'                  then @displayMessage(data)
      when 'git_master_modified'      then @gitMasterModified(data)
      when 'sale'                     then @displaySale(data)


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

  displayMessage: (data) ->
    src = $("#content")
    src.html "<div class='message-container'><div class='message'>#{data.msg}</div><div class='author'>- #{data.username} -</div></div>"
    @playSound(data)
    return

  displaySale: (data) ->
    @playSound(data)
    @displayMessage({msg: "Dollars Dollars !! #{data.amount} - #{data.country}", username: 'Zuora'})

  gitMasterModified: (data) ->
    src = $("#content")
    rows = ""
    index = 0
    commits = data.commits
    while (index < commits.length)
      rows = rows + "<tr><td>#{commits[index]["message"]}</td><td>#{commits[index]["committer"]["name"]}</td></tr>"
      ++index
    src.html "<h2>#{data.repository}-#{data.sender_name}</h2><table>#{rows}</table>"
    @playSound(data)
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
