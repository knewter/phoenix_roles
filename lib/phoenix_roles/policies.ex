defmodule PhoenixRoles.Policies do
  use PolicyWonk.Enforce
  @behaviour PolicyWonk.Policy
  alias PhoenixRoles.{User, ErrorHandlers}
  @err_handler ErrorHandlers

  def policy(assigns, :current_user) do
    case assigns[:current_user] do
      %User{} -> :ok
      _ -> :current_user
    end
  end

  def policy_error(conn, error_data) when is_bitstring(error_data) do
    @err_handler.unauthorized(conn, error_data)
  end
  def policy_error(conn, _error_data) do
    policy_error(conn, "Unauthorized")
  end
end
