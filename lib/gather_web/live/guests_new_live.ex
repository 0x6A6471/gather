defmodule GatherWeb.GuestsNewLive do
  use GatherWeb, :live_view

  alias Gather.Guests

  def render(assigns) do
    ~H"""
    <h1>New Guest</h1>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
