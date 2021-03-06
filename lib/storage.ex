defmodule Foo.Storage do
  @moduledoc """
  Stores things
  """
  use GenServer

  alias Phoenix.PubSub

  require Logger

  @doc """
  ## Options

  - `:name` name of the server
  - `:instance` helps uniquely identify the instance
  - `:source` the name of the topic to which this subscribes (as a binary).


  ## Examples

      iex> Storage.start_link(%{
        source: "in",
        name: :example,
        instance: :default
      })
  """

  def start_link(
        %{
          name: name,
          instance: instance,
          source: _
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
        %{name: name} = state
      ) do
    IO.inspect(msg, label: "Message stored by #{name}")

    {:noreply, state}
  end
end
