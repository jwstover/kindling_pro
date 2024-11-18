defmodule KindlingPro.Migrations.Policies.V01 do
  use Ecto.Migration

  def up(%{create_schema: create?, prefix: prefix} = opts) do
    %{quoted_prefix: quoted} = opts

    if create?, do: execute("CREATE SCHEMA IF NOT EXISTS #{quoted}")

    create_if_not_exists table(:kindling_policies, prefix: prefix, primary_key: false) do
      add :slug, :string, primary_key: true
      add :content, :text

      timestamps(type: :utc_datetime)
    end

    create_if_not_exists table(:kindling_policy_signatures, prefix: prefix) do
      add :policy_slug,
          references(:kindling_policies,
            column: :slug,
            type: :string,
            on_delete: :nilify_all
          )

      add :user_id, references(:users, on_delete: :delete_all)
      add :remote_ip, :string

      timestamps(type: :utc_datetime)
    end

    create_if_not_exists unique_index(:kindling_policies, [:slug], prefix: prefix)

    create_if_not_exists unique_index(
                           :kindling_policy_signatures,
                           [:policy_slug, :user_id],
                           prefix: prefix
                         )
  end

  def down(%{prefix: prefix}) do
    drop_if_exists unique_index(:kindling_policies, [:slug], prefix: prefix)

    drop_if_exists unique_index(:kindling_policy_signatures, [:policy_id, :user_id],
                     prefix: prefix
                   )

    drop_if_exists table(:kindling_policies, prefix: prefix)
    drop_if_exists table(:kindling_policy_signatures, prefix: prefix)
  end
end
