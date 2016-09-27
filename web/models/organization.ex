defmodule PhoenixRoles.Organization do
  use PhoenixRoles.Web, :model

  schema "organizations" do
    field :name, :string
    belongs_to :user, PhoenixRoles.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :user_id])
    |> validate_required([:name])
  end
end
