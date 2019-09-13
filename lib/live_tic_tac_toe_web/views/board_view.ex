defmodule LiveTicTacToeWeb.BoardView do
  use LiveTicTacToeWeb, :view

  def mark(:maru), do: "○"
  def mark(:batsu), do: "×"
  def mark(_), do: ""
end
