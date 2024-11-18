defmodule KindlingPro.Policies do
  @moduledoc false

  import Ecto.Query
  import KindlingPro.Repo

  alias KindlingPro.Policies.Policy
  alias KindlingPro.Policies.PolicySignature

  def create_policy(attrs) do
    %Policy{}
    |> Policy.changeset(attrs)
    |> repo().insert()
  end

  def create_or_update_policy(attrs) do
    slug = attrs[:slug]

    case get_policy(slug) do
      nil -> create_policy(attrs)
      policy -> update_policy(policy, attrs)
    end
  end

  def get_policy(slug) do
    from(p in Policy, where: p.slug == ^slug)
    |> repo().one()
  end

  def load_policies do
    app =
      Application.get_env(:kindling_pro, :otp_app) ||
        raise("""
        :otp_app not configured for KindlingPro.
        Please add the following to your config: 

            config :kindling_pro, otp_app: :my_app
        """)

    dir =
      Application.app_dir(app)
      |> Path.join("priv/policies/")

    policy_filenames =
      dir
      |> File.ls!()

    Enum.reduce_while(policy_filenames, :ok, fn filename, _acc ->
      [_, slug] = Regex.run(~r/(.*).md/, filename)
      file_path = Path.join(dir, filename)

      %{
        slug: slug,
        content: File.read!(file_path)
      }
      |> create_or_update_policy()
      |> case do
        {:ok, _} -> {:cont, :ok}
        {:error, err} -> {:halt, {:error, err}}
      end
    end)
  end

  def update_policy(%Policy{} = policy, attrs) do
    policy
    |> Policy.changeset(attrs)
    |> repo().update()
  end

  def sign_policy(policy_slug, user_id, remote_ip \\ nil) do
    attrs = %{
      remote_ip: remote_ip,
      user_id: user_id,
      policy_slug: policy_slug
    }

    %PolicySignature{}
    |> PolicySignature.changeset(attrs)
    |> repo().insert()
  end
end
