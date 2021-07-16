defmodule Foo.DocHelper do
  @moduledoc """
  Helps to generate the markdown-like Mermaid JS
  syntax for use in this app's documentation.

  How you assemble the string that represents the Mermaid chart is left as an
  implementation detail: you may choose to use EEx or any other means.
  """
  def render(components) do
    """
    <div class="mermaid">
    graph TD;

    classDef component fill:#D0B441,stroke:#AD9121,stroke-width:1px;
    classDef topic fill:#B5ADDF,stroke:#312378,stroke-width:1px;
    classDef db fill:#9E74BE,stroke:#4E1C74,stroke-width:1px;

    #{Enum.reduce(components, "", &render_component/2)}
    </div>
    """
  end

  def render_component(%{type: :component} = c, acc) do
    acc <>
      """
      Topic#{c.source}(#{c.source}):::topic --> Component#{c.name}{{#{c.name}}}:::server;
      Component#{c.name}{{#{c.name}}}:::server --> Topic#{c.sink}(#{c.sink}):::topic;
      """
  end

  def render_component(%{type: :storage} = c, acc) do
    acc <>
      """
      Topic#{c.source}(#{c.source}):::topic ==> Storage[("#{c.name}")]:::db;
      """
  end
end
