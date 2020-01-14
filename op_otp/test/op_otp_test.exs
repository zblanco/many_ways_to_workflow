defmodule OpOtpTest do
  use ExUnit.Case
  doctest OpOtp

  test "greets the world" do
    assert OpOtp.hello() == :world
  end
end
