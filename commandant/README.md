# Commandant

[Commanded]() based business workflow implementation in Elixir.

Commanded is a good example of a runtime abstraction for Domain Driven Design concepts like Aggregates and Process Managers.

It's worth looking under the hood to see how things like aggregates are implemented in Commanded. The same init, restart,
rebuild state, and communicate over a registry system concepts as with the `op_otp` project. The difference is that 
runtime behaviour commonalities are abstracted into the behaviour contracts and macro injections by Commanded. This has
trade-offs in some upfront mindset changes and a learning curve on top of CRUD/SQL approaches, but eventsourced data is a big win 
for many business use cases. 

Once you get the hang of implmementing a full feature through events, commands, aggregates, event-handlers,
and projections velocity improves quite a bit. However it's a bigger pill to swallow than just learning CRUD. In most cases
your projections and read-models are still using a relational database anyway so you've gotta know CRUD either way. A major
advantage is you can have as many different views and read-models as you want. Any of them are just streaming over the event
logs to build a read-model of some kind. You can tear down your database and rewrite it to fit a new reporting use case. That's
a flexibility to avoid those hairy ETL script scenarios.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `commandant` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:commandant, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/commandant](https://hexdocs.pm/commandant).

