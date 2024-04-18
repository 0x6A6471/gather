defmodule Gather.Repo.Migrations.UpdateAddressGuestsTable do
  use Ecto.Migration

  def change do
    rename table(:guests), :address, to: :address_line_1

    alter table(:guests) do
      add :address_line_2, :string, null: true
    end
  end
end
