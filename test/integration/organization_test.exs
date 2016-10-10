defmodule PhoenixRoles.Integration.OrganizationsTest do
  use PhoenixRoles.IntegrationCase, async: true
  alias PhoenixRoles.{User, Organization}

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

  test "Creating an organization", %{conn: conn, alice: alice} do
    conn
    |> log_in_as(alice)
    |> assert_response( status: 200 )
    |> create_organization(%{ name: "Alice Org" })
    |> assert_response( status: 200, path: organization_path(conn, :index) )
  end

  test "Can't view someone else's organization in index", %{conn: conn, alice: alice, bob: bob} do
    conn
    |> log_in_as(alice)
    |> assert_response( status: 200 )
    |> create_organization(%{ name: "Alice Org" })
    |> assert_response( status: 200, path: organization_path(conn, :index) )
    |> log_out
    |> assert_response( status: 200 )
    |> log_in_as(bob)
    |> assert_response( status: 200 )
    |> follow_link( "Organizations" )
    |> refute_response( html: "Alice Org" )
  end

  describe "interacting with organizations you do not own" do
    setup [:create_alice_organization]

    test "viewing an organization by URL returns unauthorized", %{conn: conn, alice_org: alice_org, bob: bob} do
      conn
      |> log_in_as(bob)
      |> get(organization_path(conn, :show, alice_org.id))
      |> assert_response( status: 404 )
    end
  end

  describe "interacting with organizations you own" do
    setup [:create_alice_organization]

    test "Can view your own organization's show page", %{conn: conn, alice: alice, alice_org: alice_org} do
      conn
      |> log_in_as(alice)
      |> assert_response( status: 200 )
      |> follow_link( "Organizations" )
      |> assert_response( status: 200, path: organization_path(conn, :index) )
      |> follow_link( organization_path(conn, :show, alice_org.id ) )
      |> assert_response( status: 200, html: "Alice Org" )
    end
  end

  def create_alice_organization(%{alice: alice}) do
    {:ok, alice_org} =
      %Organization{}
        |> Organization.changeset(%{ name: "Alice Org", user_id: alice.id })
        |> Repo.insert
    %{ alice_org: alice_org }
  end

  def log_out(conn) do
    conn
    |> delete(session_path(conn, :delete))
    |> get(page_path(conn, :index))
  end

  def log_in_as(conn, %User{email: email, password: password}) do
    # get the root index page
    get( conn, page_path(conn, :index) )
    # Sign in
    |> follow_link( "Sign In" )
    |> follow_form( %{ session: %{ email: email, password: password } } )
  end

  def create_organization(conn, org_params) do
    conn
    |> follow_link( "Organizations" )
    |> assert_response( status: 200 )
    |> follow_link( "New organization" )
    |> assert_response( status: 200, html: "New organization" )
    |> follow_form( %{ organization: org_params }, identifier: organization_path(conn, :index) )
  end
end
