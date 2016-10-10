defmodule PhoenixRoles.OrganizationController do
  use PhoenixRoles.Web, :controller
  plug PolicyWonk.LoadResource, [:organization] when action in [:show, :edit, :update, :delete]
  plug PolicyWonk.Enforce, :organization_owner when action in [:show, :edit, :update, :delete]

  alias PhoenixRoles.{Organization, User}

  def index(conn, _params) do
    query = from o in Organization,
              where: o.user_id == ^conn.assigns.current_user.id
    organizations = Repo.all(query)
    render(conn, "index.html", organizations: organizations)
  end

  def new(conn, _params) do
    changeset = Organization.changeset(%Organization{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"organization" => organization_params}) do
    organization_params = Map.put(organization_params, "user_id", conn.assigns.current_user.id)
    changeset = Organization.changeset(%Organization{}, organization_params)

    case Repo.insert(changeset) do
      {:ok, _organization} ->
        conn
        |> put_flash(:info, "Organization created successfully.")
        |> redirect(to: organization_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn=%{assigns: %{organization: organization}}, _params) do
    render(conn, "show.html", organization: organization)
  end

  def edit(conn=%{assigns: %{organization: organization}}, _params) do
    changeset = Organization.changeset(organization)
    render(conn, "edit.html", organization: organization, changeset: changeset)
  end

  def update(conn=%{assigns: %{organization: organization}}, %{"organization" => organization_params}) do
    changeset = Organization.changeset(organization, organization_params)

    case Repo.update(changeset) do
      {:ok, organization} ->
        conn
        |> put_flash(:info, "Organization updated successfully.")
        |> redirect(to: organization_path(conn, :show, organization))
      {:error, changeset} ->
        render(conn, "edit.html", organization: organization, changeset: changeset)
    end
  end

  def delete(conn=%{assigns: %{organization: organization}}, _params) do
    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(organization)

    conn
    |> put_flash(:info, "Organization deleted successfully.")
    |> redirect(to: organization_path(conn, :index))
  end

  def policy(assigns, :organization_owner) do
    case {assigns[:current_user], assigns[:organization]} do
      {%User{id: user_id}, organization=%Organization{}} ->
        case organization.user_id do
          ^user_id -> :ok
          _ -> :not_found
        end
      _ ->
        :not_found
    end
  end

  def policy_error(conn, :not_found) do
    PhoenixRoles.ErrorHandlers.resource_not_found(conn, :not_found)
  end

  def load_resource(_conn, :organization, %{"id" => id}) do
    case Repo.get(Organization, id) do
      nil -> :not_found
      organization -> {:ok, :organization, organization}
    end
  end
end
