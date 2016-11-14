defmodule Todo.Server do
  use GenServer

  def start do
    GenServer.start(Todo.Server, nil)
  end

  def add_entry(todo_sever, new_entry) do
    GenServer.cast(todo_sever, {:add_entry, new_entry})
  end

  def entries(todo_sever, date) do
    GenServer.call(todo_sever, {:entries, date})
  end

  def init(_) do
    {:ok, Todo.List.new}
  end

  def handle_cast({:add_entry, new_entry}, todo_list) do
    new_state = Todo.List.add_entry(todo_list, new_entry)
    {:noreply, new_state}
  end

  def handle_call({:entries, date}, _, todo_list) do
    {
      :reply,
      Todo.List.entries(todo_list, date),
      todo_list
    }
  end

  def handle_info(:stop, todo_list), do: {:stop, :normal, todo_list}
  def handle_info(_, state), do: {:noreply, state}
end
