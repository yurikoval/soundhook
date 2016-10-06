#= require cable
#= require_self
#= require_tree .

this.App = {}

App.cable = ActionCable.createConsumer()

App.messages = App.cable.subscriptions.create 'MessagesChannel',
  received: (data) ->
    $('#messages').removeClass 'hidden'
    $('#messages').append @renderMessage(data)
  renderMessage: (data) ->
    '<p>' + data.message + '</p>'
