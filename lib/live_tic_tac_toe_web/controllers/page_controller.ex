defmodule LiveTicTacToeWeb.PageController do
  use LiveTicTacToeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
