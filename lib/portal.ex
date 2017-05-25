defmodule Portal do
  defstruct [:source, :target]

  @doc """
  Shoots a new door with the given `color`.
  """
  def shoot(color) do
    Supervisor.start_child(Portal.Supervisor, [color])
  end

  @doc """
  Starts transfering `data` from `source` to `target`
  """
  def transfer(source, target, data) do
    for item <- data do
      Portal.Door.push(source, item)
    end

    %Portal{source: source, target: target}
  end

  @doc """
  Pushes data to the target in the given `portal`
  """
  def push(portal) do
    case Portal.Door.pop(portal.source) do
      :error  -> :ok
      {:ok, h} -> Portal.Door.push(portal.target, h)
    end

    portal
  end
end

defimpl Inspect, for: Portal do
  def inspect(%Portal{source: source, target: target}, _) do
    source_door = inspect(source)
    target_door = inspect(target)

    source_data = inspect(Enum.reverse(Portal.Door.get(source)))
    target_data = inspect(Portal.Door.get(target))

    max = max(String.length(source_door), String.length(target_door))

    """
    #Portal<
      #{String.rjust(source_door, max)} <=> #{target_door}
      #{String.rjust(source_data, max)} <=> #{target_data}
    >
    """
  end
end
