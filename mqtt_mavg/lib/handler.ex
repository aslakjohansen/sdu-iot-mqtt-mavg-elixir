defmodule MqttHandler do
  use Tortoise.Handler

  def main(args) do
    Tortoise.Supervisor.start_child(
      client_id: "my_client_id",
      handler: {Tortoise.Handler.Logger, []},
      server: {Tortoise.Transport.Tcp, host: 'localhost', port: 1883},
      subscriptions: [{"foo/bar", 0}])
    
    Tortoise.publish("my_client_id", "foo/bar", "Hello from the World of Tomorrow !", qos: 0)
    IO.puts("started")
    
    {:ok, args}
  end

  def connection(status, state) do
    # `status` will be either `:up` or `:down`; you can use this to
    # inform the rest of your system if the connection is currently
    # open or closed; tortoise should be busy reconnecting if you get
    # a `:down`
    {:ok, state}
  end

  #  topic filter room/+/temp
  def handle_message(["room", room, "temp"], payload, state) do
    # :ok = Temperature.record(room, payload)
    {:ok, state}
  end
  def handle_message(topic, payload, state) do
    # unhandled message! You will crash if you subscribe to something
    # and you don't have a 'catch all' matcher; crashing on unexpected
    # messages could be a strategy though.
    {:ok, state}
  end

  def subscription(status, topic_filter, state) do
    {:ok, state}
  end

  def terminate(reason, state) do
    # tortoise doesn't care about what you return from terminate/2,
    # that is in alignment with other behaviours that implement a
    # terminate-callback
    :ok
  end
end
