defmodule Todo.ServerSupervisor do
  use Supervisor

  def start_link do
    IO.puts "Starting ServerSupervisor."
    Supervisor.start_link(__MODULE__, nil, name: :todo_server_supervisor)
  end

  def start_child(list_name) do
    Supervisor.start_child(:todo_server_supervisor, [list_name]) |> IO.inspect
  end

  def init(_) do
    supervise([worker(Todo.Server, [])], strategy: :simple_one_for_one)
  end
end
