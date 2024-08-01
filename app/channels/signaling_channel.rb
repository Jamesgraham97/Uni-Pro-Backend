class SignalingChannel < ApplicationCable::Channel
  def subscribed
    stream_from "signaling_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    ActionCable.server.broadcast("signaling_channel", data)
  end
end
