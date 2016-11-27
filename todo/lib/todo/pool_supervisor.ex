defmodule Todo.PoolSupervisor do
  use Supervisor

  def start_link(db_folder, pool_size) do
    IO.puts "Starting PoolSupervisor, pool_size: #{pool_size}"
    Supervisor.start_link(__MODULE__, {db_folder, pool_size})
  end

  def init({db_folder, pool_size}) do
    processes = (1..pool_size |> Enum.map(fn(i) ->
      worker(Todo.DatabaseWorker, [db_folder, i], id: {:database_server, i})
    end))
    supervise(processes, strategy: :one_for_one)
  end
end
