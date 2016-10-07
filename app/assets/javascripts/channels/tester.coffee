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
  received: (data) ->
    @stopEverything()
    switch data.type
      when 'sound'                    then @playSound(data)
      when 'youtube'                  then @playYoutube(data)
      when 'message'                  then @displayMessage(data)
      when 'git_master_modified'      then @gitMasterModified(data)
      when 'sale'                     then @displaySale(data)
    setTimeout @stopEverything.bind(this), 20000


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
    @showCalendar()

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
          'onReady': @onPlayerReady.bind(this))
    @hideCalendar()
    return

  hideCalendar: -> $('#calendar').hide()
  showCalendar: -> $('#calendar').show()

  displayMessage: (data) ->
    @stopEverything()
    @hideCalendar()
    @playSound(data)
    src = $("#content")
    src.html "<div class='message-container'><div class='message-content'>#{data.msg}</div><div class='message-author'>- #{data.username} -</div></div>"
    return

  displaySale: (data) ->
    @stopEverything()
    @hideCalendar()
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
      rows = rows + "<tr class='commit-container'><td class='commit-message'>#{commits[index]["message"]}</td><td class='username'>#{commits[index]["committer"]["name"]}</td></tr>"
      ++index
    src.html "<div class='github'><div class='repository-name'><img src='#{data.sender_img}'><h2>#{data.repository}-#{data.sender_name}</h2></div><div class='commits'><table>#{rows}</table></div></div>"
    return

  onPlayerReady: (event) ->
    event.target.playVideo()
    return

  stopVideo: ->
    return true unless @player?
    @player.stopVideo()
    @player.destroy()
    @player = undefined
    return
