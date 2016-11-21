defmodule Todo.Server do
  use GenServer

  def start_link(list_name) do
    IO.puts "Starting Todo Server."

    GenServer.start_link(__MODULE__, list_name)
  end

  def add_entry(todo_sever, new_entry) do
    GenServer.cast(todo_sever, {:add_entry, new_entry})
  end

  def entries(todo_sever, date) do
    GenServer.call(todo_sever, {:entries, date})
  end

  def init(list_name) do
    send(self, :real_init)
    {:ok, {list_name, nil}}
  end

  def handle_cast({:add_entry, new_entry}, {list_name, todo_list}) do
    new_state = Todo.List.add_entry(todo_list, new_entry)
    Todo.Database.store(list_name, new_state)
    {:noreply, {list_name, new_state}}
  end

  def handle_call({:entries, date}, _, {list_name, todo_list}) do
    {
      :reply,
      Todo.List.entries(todo_list, date),
      {list_name, todo_list}
    }
  end

  def handle_info(:stop, state), do: {:stop, :normal, state}
  def handle_info(:real_init, {list_name, _}) do
    {
      :noreply,
      {list_name, Todo.Database.get(list_name) || Todo.List.new}}
  end

  def handle_info(_, state), do: {:noreply, state}
end
