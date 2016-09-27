defmodule PhoenixRoles.User do
  use PhoenixRoles.Web, :model
  use Coherence.Schema

  schema "users" do
    field :name, :string
    field :email, :string
    has_many :organizations, PhoenixRoles.Organization
    coherence_schema

    timestamps
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:name, :email] ++ coherence_fields)
    |> validate_required([:name, :email])
    |> unique_constraint(:email)
    |> validate_coherence(params)
  end
end
