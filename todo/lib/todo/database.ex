defmodule Todo.Database do
  use GenServer

  def start(db_folder) do
    GenServer.start(__MODULE__, db_folder, name: :database_server)
  end

  def store(key, value) do
    key
    |> choose_worker
    |> Todo.DatabaseWorker.store(key, value)
  end

  def get(key) do
    key
    |> choose_worker
    |> Todo.DatabaseWorker.get(key)
  end

  def choose_worker(key) do
    GenServer.call(:database_server, {:get_worker, key})
  end

  def init(db_folder) do
    File.mkdir_p(db_folder)
    worker_pids =
      0..2
      |> Enum.reduce(HashDict.new, fn (i, acc) ->
        {:ok, worker} = Todo.DatabaseWorker.start(db_folder)
        HashDict.put(acc, i, worker)
      end)
    {:ok, worker_pids}
  end

  def handle_call({:get_worker, key}, _, worker_pids) do
    worker_pid = HashDict.get(worker_pids, :erlang.phash2(key, 3))
    {:reply, worker_pid, worker_pids}
  end

  def handle_info(_, state), do: {:noreply, state}
end
