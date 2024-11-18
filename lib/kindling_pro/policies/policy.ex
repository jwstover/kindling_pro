defmodule KindlingPro.Policies.Policy do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "kindling_policies" do
    field :slug, :string, primary_key: true
    field :content, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(policy, attrs) do
    policy
    |> cast(attrs, [:slug, :content])
    |> validate_required([:slug, :content])
  end
end
