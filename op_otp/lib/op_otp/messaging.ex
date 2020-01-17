defmodule OpOtp.Messaging do
  def pub_sub, do: OpOtp.PubSub

  def subscribe(topic),
    do: Phoenix.PubSub.subscribe(pub_sub(), topic)

  def publish(message, topic),
    do: Phoenix.PubSub.broadcast(pub_sub(), topic, message)

  def unsubscribe(topic),
    do: Phoenix.PubSub.unsubscribe(pub_sub(), topic)

  def unsubscribe(pid, topic),
    do: Phoenix.PubSub.unsubscribe(pub_sub(), pid, topic)
end
