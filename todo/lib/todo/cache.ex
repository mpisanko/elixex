defmodule Todo.Cache do
  use GenServer

  def start_link do
    IO.puts "Starting Todo Cache."

    GenServer.start_link(__MODULE__, nil, name: :todo_cache)
  end

  def server_process(todo_list_name) do
    IO.puts "Cache.server_process #{todo_list_name}"
    case Todo.Server.whereis(todo_list_name) do
      :undefined -> GenServer.call(:todo_cache, {:server_process, todo_list_name})
      pid -> pid
    end |> IO.inspect
  end

  def init(_) do
    {:ok, nil}
  end

  def handle_call({:server_process, todo_list_name}, _, state) do
    server_pid = case Todo.Server.whereis(todo_list_name) do
                   :undefined ->
                     {:ok, pid} = Todo.ServerSupervisor.start_child(todo_list_name)
                     pid
                   pid -> pid
                 end
    {:reply, server_pid, state}
  end
end
