defmodule LiveTicTacToeWeb.BoardLive do
  use Phoenix.LiveView

  require Logger

  @topic "game:tic-tac-toe"

  def mount(_session, socket) do
    LiveTicTacToeWeb.Endpoint.subscribe(@topic)

    new_socket =
      socket
      |> assign_initial_values()

    {:ok, new_socket}
  end

  def render(assigns) do
    Phoenix.View.render(LiveTicTacToeWeb.BoardView, "index.html", assigns)
  end

  def handle_event("put", %{"cell" => cell}, socket) do
    cells = socket.assigns.cells
    next = socket.assigns.next
    cell_index = String.to_integer(cell)

    Logger.debug("next #{next}")
    Logger.debug("cell #{cell}")
    Logger.debug("cells #{inspect(cells)}")

    case cells[cell_index] do
      :blank ->
        new_cells = %{cells | cell_index => next}
        new_next =
          case next do
            :maru -> :batsu
            :batsu -> :maru
          end
        new_socket =
          socket
          |> assign(:next, new_next)
          |> assign(:cells, new_cells)

        LiveTicTacToeWeb.Endpoint.broadcast_from(self(), @topic, "update", %{cells: new_cells, next: new_next})
        {:noreply, new_socket}

      _ ->
        {:noreply, socket}
    end
  end

  def handle_event("clear", _, socket) do
    new_socket =
      socket
      |> assign_initial_values()

    LiveTicTacToeWeb.Endpoint.broadcast_from(self(), @topic, "clear", %{})

    {:noreply, new_socket}
  end

  def handle_info(%{event: "update", payload: %{cells: cells, next: next}}, socket) do
    new_socket =
      socket
      |> assign(:next, next)
      |> assign(:cells, cells)

    {:noreply, new_socket}
  end

  def handle_info(%{event: "clear"}, socket) do
    new_socket =
      socket
      |> assign_initial_values()

    {:noreply, new_socket}
  end

  def assign_initial_values(socket) do
    socket
    |> assign(next: :maru)
    |> assign(cells: (0..8) |> Enum.zip(Stream.cycle([:blank])) |> Map.new())
  end
end
