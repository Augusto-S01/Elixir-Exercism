# Use the Plot struct as it is provided
defmodule Plot do
  @enforce_keys [:plot_id, :registered_to]
  defstruct [:plot_id, :registered_to]
end

defmodule CommunityGarden do
  def start(opts \\ []) do
    Agent.start(fn -> [] end,opts)
  end

  def list_registrations(pid) do
   Agent.get(pid,fn state -> state[:plots] || [] end)
  end

  def register(pid, register_to) do
    Agent.get_and_update(pid, fn state ->
      count = state[:count] || 0
      plots = state[:plots] || []
  
      new_count = count + 1
      new_plot = %Plot{plot_id: new_count, registered_to: register_to}
      new_state = [count: new_count, plots: [new_plot | plots]]
  
      {new_plot, new_state}
    end)
  end


  def release(pid, plot_id) do
  Agent.get_and_update(pid, fn state ->
      count = state[:count] || 0
      plots = state[:plots] || []
  
      update_plots = Enum.filter(plots, fn plot -> plot.plot_id != plot_id end)
      
      {:ok, [count: count ,plots: update_plots]}
    end)
  end

  def get_registration(pid, plot_id) do
    case Agent.get(pid, fn state ->
           for plot <- state[:plots] || [], plot.plot_id == plot_id, do: plot
         end) do
      [] -> {:not_found, "plot is unregistered"}
      [plot | _] -> plot  
    end
  end

end
