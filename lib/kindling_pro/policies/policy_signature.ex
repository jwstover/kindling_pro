defmodule KindlingPro.Policies.PolicySignature do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias KindlingPro.Policies.Policy

  schema "kindling_policy_signatures" do
    field :remote_ip, :string

    belongs_to :policy, Policy, foreign_key: :policy_slug, type: :string
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  def changeset(policy_signature, attrs) do
    policy_signature
    |> cast(attrs, [:remote_ip, :policy_slug, :user_id])
    |> validate_required([:policy_slug, :user_id])
  end
end
