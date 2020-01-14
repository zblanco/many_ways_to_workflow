# Many Ways to Workflow - Example Repo

Examples of business workflows written with different Elixir patterns.

Workflow modeled: Permit Submission Tracking.

See the [first blog post](zblanco.io) in the series for more information.

## Contents

### Cruddite

The usual choice of exploiting the powers of Create Read Update and Delete for great good.

Implemented with Ecto and Postgres.

### OP OTP

Uses OTP directly to implement the runtime behaviours enforced by a vanilla Elixir Struct and Module.

Implemented with a GenServer, Dynamic Supervisor, and Elixir's Registry.

### Commandant

Uses the Commanded library to implement the Permit Tracking workflow with CQRS, Event-sourcing, and DDD abstractions.

Ecto and Postgres are used for a read-model projection.