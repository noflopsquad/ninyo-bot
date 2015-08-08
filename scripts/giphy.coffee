giphy =
  api_key: process.env.HUBOT_GIPHY_API_KEY
  base_url: 'http://api.giphy.com/v1'

module.exports = (robot) ->
  robot.respond /(gifeame)( un| una)? (.*)/i, (msg) ->
    giphyMe msg, msg.match[3], (url) ->
      msg.send url

giphyMe = (msg, query, cb) ->
  endpoint = '/gifs/translate'
  url = "#{giphy.base_url}#{endpoint}"

  msg.http(url)
    .query
      s: query
      api_key: giphy.api_key
    .get() (err, res, body) ->
      response = undefined
      try
        response = JSON.parse(body)
        image = msg.random response.data.images
        cb image.original.url

      catch e
        response = undefined
        cb 'Error'

      return if response is undefined