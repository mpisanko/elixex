defmodule Todo.ProcessRegistry do
  use GenServer
  import Kernel, except: [send: 2]

  def init(_) do
    {:ok, HashDict.new}
  end

  def handle_call({:register_name, key, pid}, _, process_registry) do
    case HashDict.get(process_registry, key) do
      nil ->
        Process.monitor(pid)
        {:reply, :yes, HashDict.put(process_registry, key, pid)}
      _ ->
        {:reply, :no, process_registry}
    end
  end

  def handle_call({:whereis_name, key}, _, process_registry) do
    {
      :reply,
      HashDict.get(process_registry, key, :undefined),
      process_registry
    }
  end

  def send(key, message) do
    case whereis_name(key) do
      :undefined -> {:badarg, {key, message}}
      pid ->
        Kernel.send(pid, messaage)
        pid
    end
  end

  def handle_info({:DOWN, _, :process, pid, _}, process_registry) do
    {:noreply, :deregister_pid(process_registry, pid)}
  end

  defp deregister_pid(process_registry, pid) do
    HashDict.delete(process_registry, pid)
  end
end
