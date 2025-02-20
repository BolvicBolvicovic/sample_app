defmodule SampleApp.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
