defmodule Todo.ListTest do
  use ExUnit.Case
  doctest Todo.List

  test "creates an empty todo list" do
    assert Todo.List.new |> Todo.List.size == 0
  end

  test "adding entry increases size to 1" do
    assert Todo.List.new
    |> Todo.List.add_entry(%{date: {2016,11,24}, title: "xmas party"})
    |> Todo.List.size == 1
  end
end
