defmodule PhoenixRoles.Integration.OrganizationsTest do
  use PhoenixRoles.IntegrationCase, async: true
  alias PhoenixRoles.User

  setup do
    Repo.delete_all(User)
    alice =
      %User{}
        |> User.changeset(%{name: "Alice", email: "alice@example.com", password: "password", password_confirmation: "password"})
        |> Repo.insert!

    bob =
      %User{}
        |> User.changeset(%{name: "Bob", email: "bob@example.com", password: "password", password_confirmation: "password"})
        |> Repo.insert!

    {:ok, %{alice: alice, bob: bob}}
  end

  test "Creating an organization", %{conn: conn, alice: alice, bob: bob} do
    # get the root index page
    get( conn, page_path(conn, :index) )
    # Sign in
    |> follow_link( "Sign In" )
    |> follow_form( %{ session: %{ email: alice.email, password: alice.password } } )
    |> assert_response( status: 200 )
    |> follow_link( "Organizations" )
    |> assert_response( status: 200 )
    |> follow_link( "New organization" )
    |> assert_response( status: 200, html: "New organization" )
    |> follow_form( %{ organization: %{ name: "Alice Org" } }, identifier: organization_path(conn, :index) )
    |> assert_response( status: 200, path: organization_path(conn, :index) )
  end
end
