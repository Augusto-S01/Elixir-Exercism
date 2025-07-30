defmodule DancingDots.Animation do
  @type dot :: DancingDots.Dot.t()
  @type opts :: keyword
  @type error :: any
  @type frame_number :: pos_integer

  @callback init(opts()) :: {:ok,opts()} | {:error,error()}
  @callback handle_frame(dot(),frame_number(),opts())  :: dot()

  defmacro __using__(_) do
    quote do
      @behaviour DancingDots.Animation
      def init(opts), do: {:ok,opts}
      defoverridable init: 1

    end
  end

end



defmodule DancingDots.Flicker do
  use DancingDots.Animation

  @impl DancingDots.Animation
  def handle_frame(dot, frame, _opts) do
    cond do
      rem(frame,4) == 0 -> %{dot | opacity: dot.opacity/2 }
      true -> dot
    end
  end

end

defmodule DancingDots.Zoom do
  use DancingDots.Animation

  @impl DancingDots.Animation
  def init(opts) do
    velocity = Keyword.get(opts,:velocity)
      case is_number(velocity) do
        true -> {:ok,opts}
        _ -> {:error,"The :velocity option is required, and its value must be a number. Got: #{inspect(velocity)}"}
      end
  end



  @impl DancingDots.Animation
  def handle_frame(dot, frame, opts) do
    cond do
      frame == 1 -> dot
      true ->
        %{dot | radius: dot.radius +  (frame - 1 ) * Keyword.get(opts,:velocity) }
    end

  end
end
