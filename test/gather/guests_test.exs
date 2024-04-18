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
      address_line_1: nil,
      city: nil,
      guest_amount: nil,
      rsvp_sent: nil,
      invite_sent: nil,
      save_the_date_sent: nil
    }

    test "list_guests/0 returns all guests associated to the user" do
      guest = guest_fixture()
      assert Guests.list_guests(1) == [guest]
    end

    test "get_guest!/1 returns the guest with given id" do
      guest = guest_fixture()
      assert Guests.get_guest!(guest.id) == guest
    end

    test "create_guest/1 with valid data creates a guest" do
      valid_attrs = %{
        name: "some name",
        state: "some state",
        zip: "12345",
        address_line_1: "some address",
        address_line_2: "line 2",
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
      assert guest.zip == "12345"
      assert guest.address_line_1 == "some address"
      assert guest.address_line_2 == "line 2"
      assert guest.city == "some city"
      assert guest.guest_amount == 42
      assert guest.rsvp_sent == true
      assert guest.invite_sent == true
      assert guest.save_the_date_sent == true
    end

    test "create_guest/1 creates guests without address_line_2" do
      valid_attrs = %{
        name: "some name",
        state: "some state",
        zip: "12345",
        address_line_1: "some address",
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
      assert guest.zip == "12345"
      assert guest.address_line_1 == "some address"
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
        zip: "00000",
        address_line_1: "some updated address",
        address_line_2: "updated line 2",
        city: "some updated city",
        guest_amount: 43,
        rsvp_sent: false,
        invite_sent: false,
        save_the_date_sent: false
      }

      assert {:ok, %Guest{} = guest} = Guests.update_guest(guest, update_attrs)
      assert guest.name == "some updated name"
      assert guest.state == "some updated state"
      assert guest.zip == "00000"
      assert guest.address_line_1 == "some updated address"
      assert guest.address_line_2 == "updated line 2"
      assert guest.city == "some updated city"
      assert guest.guest_amount == 43
      assert guest.rsvp_sent == false
      assert guest.invite_sent == false
      assert guest.save_the_date_sent == false
    end

    test "update_guest/2updates the guest without address_line_2" do
      guest = guest_fixture()

      update_attrs = %{
        name: "some updated name",
        state: "some updated state",
        zip: "00000",
        address_line_1: "some updated address",
        city: "some updated city",
        guest_amount: 43,
        rsvp_sent: false,
        invite_sent: false,
        save_the_date_sent: false
      }

      assert {:ok, %Guest{} = guest} = Guests.update_guest(guest, update_attrs)
      assert guest.name == "some updated name"
      assert guest.state == "some updated state"
      assert guest.zip == "00000"
      assert guest.address_line_1 == "some updated address"
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
      assert {:ok, %Guest{}} = Guests.delete_guest(guest.id)
      assert_raise Ecto.NoResultsError, fn -> Guests.get_guest!(guest.id) end
    end

    test "change_guest/1 returns a guest changeset" do
      guest = guest_fixture()
      assert %Ecto.Changeset{} = Guests.change_guest(guest)
    end
  end
end
