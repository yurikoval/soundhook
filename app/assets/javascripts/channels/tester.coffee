#= require cable
#= require_self
#= require_tree .

this.App = {}

App.cable = ActionCable.createConsumer()

App.messages = App.cable.subscriptions.create 'MessagesChannel',
  received: (data) ->
    $('#messages').append @renderMessage(data)
    @playSound(data)
  renderMessage: (data) ->
    '<p>' + data.message + '</p>'

  playSound: (data) ->
    src = $("#player")
    src.attr 'src', data.sound_url
    src.attr 'type', data.format
    src.trigger('load')
    src.trigger('play')
