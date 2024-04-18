defmodule GatherWeb.GuestsController do
  use GatherWeb, :controller

  alias Gather.Guests

  def create(conn, %{"_action" => "guest_created"} = params) do
    conn
    |> put_session(:user_return_to, ~p"/guests")
    |> create(params, "Guest added successfully!")
  end

  defp create(conn, %{"guest" => guest_params}, _info) do
    user = conn.assigns.current_user

    if user do
      case Guests.create_guest(user, guest_params) do
        {:ok, guest} ->
          conn
          |> put_flash(:success, "#{guest.name} added successfully.")
          |> redirect(to: "/guests")

        {:error, _changeset} ->
          conn
          |> put_flash(:error, "Failed to create guest.")
      end
    else
      conn
      |> put_flash(:error, "User not found.")
    end
  end
end
