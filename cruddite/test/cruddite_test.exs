defmodule CrudditeTest do
  use ExUnit.Case
  doctest Cruddite

  test "greets the world" do
    assert Cruddite.hello() == :world
  end
end
