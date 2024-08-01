# lib/web_socket_server.rb

require 'faye/websocket'
require 'thread'
require 'redis'
require 'json'

class WebSocketServer
  KEEPALIVE_TIME = 15 # in seconds
  CHANNEL = 'webrtc_signaling'

  def initialize(app)
    @app = app
    @clients = []
  end

  def call(env)
    if Faye::WebSocket.websocket?(env)
      ws = Faye::WebSocket.new(env, nil, { ping: KEEPALIVE_TIME })

      ws.on :open do |event|
        @clients << ws
      end

      ws.on :message do |event|
        msg = JSON.parse(event.data)
        @clients.each { |client| client.send(event.data) unless client == ws }
      end

      ws.on :close do |event|
        @clients.delete(ws)
        ws = nil
      end

      ws.rack_response
    else
      @app.call(env)
    end
  end
end
