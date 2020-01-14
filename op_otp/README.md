# OpOtp

OTP based workflow implementations using minimal dependencies for runtime abstractions.

Permit Tracker Feature:

Track lifecycle of a permit for some kind of operation that needs authorization with an outside entity.

* Module - Rule & Reduce
* Runtime:
  * GenServer managed state
  * Dynamic Supervision
  * Registry communication via permit_id
* Dependencies:
  * Optional: Persistence & Query Behaviours & Implementations

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `op_otp` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:op_otp, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/op_otp](https://hexdocs.pm/op_otp).

