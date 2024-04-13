defmodule Gather.Repo.Migrations.CreateGuestsTable do
  use Ecto.Migration

  def change do
    create table(:guests) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :name, :string, null: false
      add :address, :string, null: false
      add :city, :string, null: false
      add :state, :string, null: false
      add :zip, :string, null: false
      add :guest_amount, :integer, default: 1
      add :rsvp_sent, :boolean, default: false
      add :invite_sent, :boolean, default: false
      add :save_the_date_sent, :boolean, default: false
      timestamps(type: :utc_datetime)
    end
  end
end
