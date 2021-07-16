defmodule Foo.Application do
  @components [
    %{type: :component, name: "compA", instance: :default, source: "input", sink: "bus1"},
    %{type: :component, name: "compB", instance: :default, source: "input", sink: "bus2"},
    %{type: :component, name: "compC", instance: :default, source: "input", sink: "bus3"},
    %{type: :component, name: "compB2", instance: :default, source: "bus2", sink: "out"},
    %{type: :component, name: "compC2", instance: :default, source: "bus3", sink: "storage"},
    %{type: :storage, name: "storage", instance: :default, source: "bus3"}
  ]
  @moduledoc """
  The following chart is generated dynamically:

  #{Foo.DocHelper.render(@components)}
  """

  use Application

  require Logger

  @impl true
  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Digestex.Supervisor]

    Supervisor.start_link(
      [{Phoenix.PubSub, name: :pubsub}] ++ component_specs(@components, :default),
      opts
    )
  end

  @doc """
  Returns a list of specs for the components provided.
  """
  def component_specs(components, instance) do
    components
    |> Enum.map(fn
      %{type: :component} = config ->
        Supervisor.child_spec(
          {Foo.GenComponent,
           %{
             name: Map.fetch!(config, :name),
             instance: instance,
             source: Map.fetch!(config, :source),
             sink: Map.fetch!(config, :sink)
           }},
          id: :"#{instance}.#{Map.fetch!(config, :name)}"
        )

      %{type: :storage} = config ->
        Supervisor.child_spec(
          {Foo.Storage,
           %{
             name: Map.fetch!(config, :name),
             instance: instance,
             source: Map.fetch!(config, :source)
           }},
          id: :"#{instance}.#{Map.fetch!(config, :name)}"
        )
    end)
  end
end
