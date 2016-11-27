defmodule Todo.Supervisor do
  use Supervisor

  def start_link do
    IO.puts "Starting Supervisor."

    Supervisor.start_link(__MODULE__, nil)
  end

  def init(_) do
    processes = [
      worker(Todo.ProcessRegistry, []),
      worker(Todo.PoolSupervisor, ["./persist", 3]),
      worker(Todo.Cache, [])
    ]
    supervise(processes, strategy: :one_for_one)
  end
end
