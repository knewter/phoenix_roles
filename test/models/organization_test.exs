defmodule PhoenixRoles.OrganizationTest do
  use PhoenixRoles.ModelCase

  alias PhoenixRoles.Organization

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Organization.changeset(%Organization{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Organization.changeset(%Organization{}, @invalid_attrs)
    refute changeset.valid?
  end
end
