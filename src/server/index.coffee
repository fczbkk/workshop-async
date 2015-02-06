express = require 'express'
app = express()

app.get '/', (req, res) ->
  res.send 'Hello World!'

app.get '/delay/:delay', (req, res) ->
  delay = parseInt(req.params.delay)
  renderPage = -> res.send "#{delay}"
  setTimeout renderPage, delay

server = app.listen 3000, ->
  host = server.address().address
  port = server.address().port
  console.log "Server running at http://#{host}:#{port}"
