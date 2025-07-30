defmodule TakeANumberDeluxe do
  use GenServer

  @spec start_link(keyword()) :: {:ok, pid()} | {:error, atom()}
  def start_link(init_arg) do
    GenServer.start(__MODULE__, init_arg)
  end

  @spec report_state(pid()) :: TakeANumberDeluxe.State.t()
  def report_state(machine), do: GenServer.call(machine, :report)

  @spec queue_new_number(pid()) :: {:ok, integer()} | {:error, atom()}
  def queue_new_number(machine), do: GenServer.call(machine, :queue_new_number)

  @spec serve_next_queued_number(pid(), integer() | nil) :: {:ok, integer()} | {:error, atom()}
  def serve_next_queued_number(machine, priority_number \\ nil),
    do: GenServer.call(machine, {:serve_next_queue, priority_number})

  @spec reset_state(pid()) :: :ok
  def reset_state(machine), do: GenServer.call(machine, :reset)

  # Server Callbacks

  @impl GenServer
  def init(init_arg) do
    case TakeANumberDeluxe.State.new(
           init_arg[:min_number],
           init_arg[:max_number],
           Keyword.get(init_arg, :auto_shutdown_timeout, :infinity)
         ) do
      {:ok, state} -> {:ok, state, state.auto_shutdown_timeout}
      {:error, reason} -> {:stop, reason}
    end
  end

  @impl GenServer
  def handle_call(:report, _from, state) do
    {:reply, state, state, state.auto_shutdown_timeout}
  end

  @impl GenServer
  def handle_call(:queue_new_number, _from, state) do
    case TakeANumberDeluxe.State.queue_new_number(state) do
      {:ok, new_number, new_state} ->
        {:reply, {:ok, new_number}, new_state, new_state.auto_shutdown_timeout}

      {:error, reason} ->
        {:reply, {:error, reason}, state, state.auto_shutdown_timeout}
    end
  end

  @impl GenServer
  def handle_call({:serve_next_queue, priority}, _from, state) do
    case TakeANumberDeluxe.State.serve_next_queued_number(state, priority) do
      {:ok, next_number, new_state} ->
        {:reply, {:ok, next_number}, new_state, new_state.auto_shutdown_timeout}

      {:error, error} ->
        {:reply, {:error, error}, state, state.auto_shutdown_timeout}
    end
  end

  @impl GenServer
  def handle_call(:reset, _from, state) do
    case TakeANumberDeluxe.State.new(
           state.min_number,
           state.max_number,
           state.auto_shutdown_timeout
         ) do
      {:ok, new_state} ->
        {:reply, :ok, new_state, new_state.auto_shutdown_timeout}

      {:error, reason} ->
        {:reply, {:error, reason}, state, state.auto_shutdown_timeout}
    end
  end

  @impl GenServer
  def handle_call(_request, _from, state) do
    {:reply, {:error, :unknown_request}, state, state.auto_shutdown_timeout}
  end

  @impl GenServer
  def handle_info(:timeout, state) do
    {:stop, :normal, state}
  end

  @impl GenServer
  def handle_info(_msg, state) do
    {:noreply, state, state.auto_shutdown_timeout}
  end
end
