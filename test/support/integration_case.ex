defmodule PhoenixRoles.IntegrationCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use PhoenixRoles.ConnCase
      use PhoenixIntegration
    end
  end
end
