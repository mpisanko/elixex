defmodule Todo.Supervisor do
  use Supervisor

  def start_link do
    IO.puts "Starting Supervisor."

    Supervisor.start_link(__MODULE__, nil)
  end

  def init(_) do
    processes = [
      worker(Todo.Database, ["./persist"]),
      worker(Todo.ServerSupervisor, []),
      worker(Todo.Cache, [])
    ]
    supervise(processes, strategy: :one_for_one)
  end
end
