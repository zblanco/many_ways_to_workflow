defmodule CommandantTest do
  use ExUnit.Case
  doctest Commandant

  test "greets the world" do
    assert Commandant.hello() == :world
  end
end
