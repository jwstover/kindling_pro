defmodule KindlingProWeb.Layouts do
  @moduledoc false

  use KindlingProWeb, :html

  use KindlingUI.Components

  embed_templates "layouts/*"
end
