defmodule Gather.GuestsTest do
  use Gather.DataCase

  alias Gather.AccountsFixtures
  alias Gather.Guests

  describe "guests" do
    alias Gather.Guests.Guest

    import Gather.GuestsFixtures

    @invalid_attrs %{
      name: nil,
      state: nil,
      zip: nil,
      address: nil,
      city: nil,
      guest_amount: nil,
      rsvp_sent: nil,
      invite_sent: nil,
      save_the_date_sent: nil
    }

    test "list_guests/0 returns all guests" do
      guest = guest_fixture()
      assert Guests.list_guests() == [guest]
    end

    test "get_guest!/1 returns the guest with given id" do
      guest = guest_fixture()
      assert Guests.get_guest!(guest.id) == guest
    end

    test "create_guest/1 with valid data creates a guest" do
      valid_attrs = %{
        name: "some name",
        state: "some state",
        zip: "some zip",
        address: "some address",
        city: "some city",
        guest_amount: 42,
        rsvp_sent: true,
        invite_sent: true,
        save_the_date_sent: true
      }

      user = AccountsFixtures.user_fixture()

      assert {:ok, %Guest{} = guest} = Guests.create_guest(user, valid_attrs)
      assert guest.name == "some name"
      assert guest.state == "some state"
      assert guest.zip == "some zip"
      assert guest.address == "some address"
      assert guest.city == "some city"
      assert guest.guest_amount == 42
      assert guest.rsvp_sent == true
      assert guest.invite_sent == true
      assert guest.save_the_date_sent == true
    end

    test "create_guest/1 with invalid data returns error changeset" do
      user = AccountsFixtures.user_fixture()

      assert {:error, %Ecto.Changeset{}} = Guests.create_guest(user, @invalid_attrs)
    end

    test "update_guest/2 with valid data updates the guest" do
      guest = guest_fixture()

      update_attrs = %{
        name: "some updated name",
        state: "some updated state",
        zip: "some updated zip",
        address: "some updated address",
        city: "some updated city",
        guest_amount: 43,
        rsvp_sent: false,
        invite_sent: false,
        save_the_date_sent: false
      }

      assert {:ok, %Guest{} = guest} = Guests.update_guest(guest, update_attrs)
      assert guest.name == "some updated name"
      assert guest.state == "some updated state"
      assert guest.zip == "some updated zip"
      assert guest.address == "some updated address"
      assert guest.city == "some updated city"
      assert guest.guest_amount == 43
      assert guest.rsvp_sent == false
      assert guest.invite_sent == false
      assert guest.save_the_date_sent == false
    end

    test "update_guest/2 with invalid data returns error changeset" do
      guest = guest_fixture()
      assert {:error, %Ecto.Changeset{}} = Guests.update_guest(guest, @invalid_attrs)
      assert guest == Guests.get_guest!(guest.id)
    end

    test "delete_guest/1 deletes the guest" do
      guest = guest_fixture()
      assert {:ok, %Guest{}} = Guests.delete_guest(guest)
      assert_raise Ecto.NoResultsError, fn -> Guests.get_guest!(guest.id) end
    end

    test "change_guest/1 returns a guest changeset" do
      guest = guest_fixture()
      assert %Ecto.Changeset{} = Guests.change_guest(guest)
    end
  end
end
