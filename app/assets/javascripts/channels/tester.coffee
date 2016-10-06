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
    @emptyPage()

  playSound: (data) ->
    src = $("#player")
    src.attr 'src', data.sound_url
    src.attr 'type', data.format
    src.trigger('load')
    src.trigger('play')

  stopSound: ->
    src = $("#player")
    src.trigger('pause')

  emptyPage: ->
    console.log("empty page")
    src = $("#content")
    src.html ""

  playYoutube: (data) ->
    @stopEverything()
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
    @stopEverything()
    @playSound(data)
    src = $("#content")
    src.html "<div class='message-container'><div class='message-content'>#{data.msg}</div><div class='message-author'>- #{data.username} -</div></div>"
    return

  displaySale: (data) ->
    @stopEverything()
    src = $("#content")
    src.html "<div class='sale'><div class='sale-container'><div class='sale-content'>Dalla dalla billz, y'all! </div><div class='sale-icon'><img width='70' src='http://pix.iemoji.com/images/emoji/apple/ios-9/256/banknote-with-dollar-sign.png'><img width='70' src='http://pix.iemoji.com/images/emoji/apple/ios-9/256/banknote-with-dollar-sign.png'><img width='70' src='http://pix.iemoji.com/images/emoji/apple/ios-9/256/banknote-with-dollar-sign.png'></div><div class='sale-info'>#{data.amount} from #{data.country}</div></div></div>"
    @playSound(data)
    return

  gitMasterModified: (data) ->
    @stopEverything()
    @playSound(data)
    src = $("#content")
    rows = ""
    index = 0
    commits = data.commits
    while (index < commits.length)
      rows = rows + "<tr><td>#{commits[index]["message"]}</td><td>#{commits[index]["committer"]["name"]}</td></tr>"
      ++index
    src.html "<h2>#{data.repository}-#{data.sender_name}</h2><table>#{rows}</table>"
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
