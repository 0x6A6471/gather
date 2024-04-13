defmodule Gather.GuestsFixtures do
  alias Gather.AccountsFixtures
  alias Gather.Guests

  @moduledoc """
  This module defines test helpers for creating
  entities via the `Gather.Guests` context.
  """

  @doc """
  Generate a guest.
  """
  def guest_fixture(attrs \\ %{}) do
    # Create or get a user fixture
    user = AccountsFixtures.user_fixture()

    # Prepare attributes for the guest
    guest_attrs =
      %{
        name: "some name",
        address: "some address",
        city: "some city",
        state: "some state",
        zip: "some zip",
        guest_amount: 2,
        invite_sent: false,
        rsvp_sent: false,
        save_the_date_sent: false
      }
      |> Enum.into(attrs)

    # Create the guest using the user
    {:ok, guest} = Guests.create_guest(user, guest_attrs)
    guest
  end
end

