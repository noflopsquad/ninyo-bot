# Description:
#   Hubot's pomodoro timer
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot start pomodoro - start a new pomodoro
#   hubot start pomodoro <time> - start a new pomodoro with a duration of <time> minutes
#   hubot stop pomodoro - stop a pomodoro
#   hubot pomodoro? - shows the details of the current pomodoro
#   hubot total pomodoros - shows the number of the total completed pomodoros
#
# Author:
#   mcollina

currentPomodoro = null
defaultLength = 25

module.exports = (robot) ->

  robot.brain.data.pomodoros ||= 0

  robot.respond /start pomodoro ?(\d+)?/i, (msg) ->

    if currentPomodoro?
      msg.send "Ya está arrancado el pomodoro, tarao."
      return

    currentPomodoro = {}

    currentPomodoro.func = ->
      msg.send "@team Pomodoro terminao!"
      currentPomodoro = null
      robot.brain.data.pomodoros += 1

    currentPomodoro.time = new Date()
    currentPomodoro.length = defaultLength
    currentPomodoro.length = parseInt(msg.match[1]) if msg.match[1]?

    msg.send "Pomodoro arrancao!"

    currentPomodoro.timer = setTimeout(currentPomodoro.func, currentPomodoro.length * 60 * 1000)

  robot.respond /pomodoro\?/i, (msg) ->
    unless currentPomodoro?
      msg.send "No has arrancao ningún pomodoro, tarao"
      return

    minutes = currentPomodoro.time.getTime() + currentPomodoro.length * 60 * 1000
    minutes -= new Date().getTime()

    minutes = Math.round(minutes / 1000 / 60)

    msg.send "Todavía le quedan #{minutes} minutos al pomodoro"

  robot.respond /stop pomodoro/i, (msg) ->
    unless currentPomodoro?
      msg.send "No has arrancao ningún pomodoro, tarao"
      return

    clearTimeout(currentPomodoro.timer)

    currentPomodoro = null
    msg.send "Pomodoro parao!"

  robot.respond /total pomodoros/i, (msg) ->
    msg.send "Habéis hecho #{robot.brain.data.pomodoros} pomodoros, taraos"