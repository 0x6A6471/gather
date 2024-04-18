defmodule Gather.Guests.Guest do
  use Ecto.Schema
  import Ecto.Changeset

  schema "guests" do
    field :name, :string
    field :state, :string
    field :zip, :string
    field :address_line_1, :string
    field :address_line_2, :string
    field :city, :string
    field :guest_amount, :integer
    field :rsvp_sent, :boolean, default: false
    field :invite_sent, :boolean, default: false
    field :save_the_date_sent, :boolean, default: false
    belongs_to :user, Gather.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(guest, attrs) do
    guest
    |> cast(attrs, [
      :name,
      :address_line_1,
      :address_line_2,
      :city,
      :state,
      :zip,
      :guest_amount,
      :rsvp_sent,
      :invite_sent,
      :save_the_date_sent,
      :user_id
    ])
    |> validate_required([
      :name,
      :address_line_1,
      :city,
      :state,
      :zip,
      :guest_amount,
      :rsvp_sent,
      :invite_sent,
      :save_the_date_sent,
      :user_id
    ])
    |> validate_number(:guest_amount, greater_than_or_equal_to: 1)
    |> validate_length(:zip, is: 5)
  end
end
