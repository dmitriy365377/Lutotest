http = require 'http'

expectedURL = ///
 ^/query/data/(\w+)/param/(\w+)$
///

response404 = (res, data) ->
  res.writeHead 404, 'Content-Type': 'application/json'
  res.write JSON.stringify data, null, 2
  res.end()
  return

response = (res, data) ->
  body = JSON.stringify data
  res.writeHead 200,
    'Content-Type': 'application/json'
    'Access-Control-Allow-Origin': '*'
    'Content-Length': Buffer.byteLength body, 'utf8'
  res.write body
  res.end()

request = (req, res) ->
  params = req.url.match expectedURL
  unless params
    console.error 404, req.url
    return response404 res, {error: 'entry point not found'}
  if params[2] is '404'
    console.log 404, req.url
    return response404 res, {error: 'data is broken'}
  console.log 200, req.url
  if params[1] is '1'
    return response res, [null, {v: 1}, {v: 4}, null]
  response res, [null, {v: 1}, {v: 4}, {v: 0}, null]
  return

server = http.createServer()
server
  .on 'request', request
  .on 'error', (err) ->
    console.error err
    return
  .listen 8086, '0.0.0.0', ->
    console.log 'start server'
    return
