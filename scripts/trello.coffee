# Description:
#   Create new cards in Trello
#
# Dependencies:
#   "node-trello": "latest"
#
# Configuration:
#   HUBOT_TRELLO_KEY - Trello application key
#   HUBOT_TRELLO_TOKEN - Trello API token
#   HUBOT_TRELLO_LIST - The list ID that you'd like to create cards for
#
# Commands:
#   hubot trello card <name> - Create a new Trello card
#   hubot trello show - Show cards on list
#
# Notes:
#   To get your key, go to: https://trello.com/1/appKey/generate
#   To get your token, go to: https://trello.com/1/authorize?key=<<your key>>&name=Hubot+Trello&expiration=never&response_type=token&scope=read,write
#   Figure out what board you want to use, grab it's id from the url (https://trello.com/board/<<board name>>/<<board id>>)
#   To get your list ID, go to: https://trello.com/1/boards/<<board id>>/lists?key=<<your key>>&token=<<your token>>  "id" elements are the list ids.
#
# Author:
#   carmstrong

module.exports = (robot) ->
  robot.respond /trello/i, (msg) ->
    showCards msg

showCards = (msg) ->
  Trello = require("node-trello")
  trello = new Trello(process.env.HUBOT_TRELLO_KEY, process.env.HUBOT_TRELLO_TOKEN)
  # t.get "/1/lists/"+process.env.HUBOT_TRELLO_LIST, {cards: "open"}, (err, data) ->
  #   if err
  #     msg.send "There was an error showing the list."
  #     return

  covakanban = {
    id: 'EnLaiGDn',
    lists: {
      todo: { 
        id: '53107c377f061f2c12992601',
        name: 'To Do'
      },
      doing: {
        id: '53107c377f061f2c12992603',
        name: 'Done'
        }
      }  
    } 


  trello.get "/1/lists/53107c377f061f2c12992601/cards", {}, (err, data) ->
    list = ""
    for card in data
      list += '- ' + card.name
      if card.due
        list += '. Te se caduca el ' + card.due.split('T')[0]

      list += '\n'
    msg.send 'Teneis estas mierdas por hacer putos vagos:'
    msg.send list
    console.log err
