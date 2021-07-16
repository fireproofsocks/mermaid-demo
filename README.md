# Foo

A demo of using Mermaid charts inside Elixir documentation made in support of the article
[Enhancing Elixir Documentation with Mermaid Charts](https://fireproofsocks.medium.com/enhancing-elixir-documentation-with-mermaid-charts-340fad5c6426)

## Run the App

This is just a demo app -- it doesn't do anything substantial, however you can witness that it passes messages around between components via PubSub topics.

Start `iex`, then broadcast a message.  You should see something like this:

```
iex> Phoenix.PubSub.broadcast(:pubsub, "input", {:message, "test message"})
Message handled by compC component: "test message"
Message handled by compA component: "test message"
Message handled by compB component: "test message"
:ok
Message stored by storage: "test message"
Message handled by compB2 component: "test message"
Message handled by compC2 component: "test message"
```

## Generate Documentation

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/foo](https://hexdocs.pm/foo).

Run `mix docs` and inspect the output in the `doc/` folder.
