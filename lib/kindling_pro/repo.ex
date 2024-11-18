defmodule KindlingPro.Repo do
  @moduledoc false

  def repo do
    Application.get_env(:kindling_pro, :repo) ||
      raise("""
      No Ecto.Repo module configured for KindlingPro. 
      Please add the following to your config: 

          config :kindling_pro, repo: MyApp.Repo
      """)
  end
end
