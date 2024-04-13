defmodule Gather.Repo.Migrations.CreateGuests do
  use Ecto.Migration

  def change do
    create table(:guests) do
      add :name, :string, null: false
      add :address, :string, null: false
      add :city, :string, null: false
      add :state, :string, null: false
      add :zip, :string, null: false
      add :guest_amount, :integer, default: 1, null: false
      add :rsvp_sent, :boolean, default: false, null: false
      add :invite_sent, :boolean, default: false, null: false
      add :save_the_date_sent, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:guests, [:user_id])
  end
end
