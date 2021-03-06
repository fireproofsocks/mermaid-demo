defmodule Foo.GenComponent do
  @moduledoc """
  A generic server that does something in our app
  """
  use GenServer

  alias Phoenix.PubSub

  require Logger

  @doc """
  ## Options

  - `:name` name of the server
  - `:instance` helps uniquely identify the instance
  - `:source` the name of the topic to which this subscribes (as a binary).
  - `:sink` the name of the topic to which this broadcasts (as a binary).


  ## Examples

      iex> GenComponent.start_link(%{
        source: "in",
        sink: "out",
        name: :example,
        instance: :default
      })
  """

  def start_link(
        %{
          name: name,
          instance: instance,
          source: _,
          sink: _
        } = opts
      ) do
    GenServer.start_link(__MODULE__, opts, name: :"#{instance}.#{name}")
  end

  def start_link(opts) when is_list(opts), do: opts |> Enum.into(%{}) |> start_link()

  @impl true
  def init(%{source: source} = state) do
    PubSub.subscribe(:pubsub, source, [])
    {:ok, state}
  end

  @impl true
  def handle_info(
        {:message, msg},
        %{sink: sink, name: name} = state
      ) do
    IO.inspect(msg, label: "Message handled by #{name} component")
    PubSub.broadcast(:pubsub, sink, {:message, msg})

    {:noreply, state}
  end
end
