# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PhoenixRoles.Repo.insert!(%PhoenixRoles.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
PhoenixRoles.Repo.delete_all PhoenixRoles.User

%PhoenixRoles.User{}
  |> PhoenixRoles.User.changeset(%{name: "Josh Adams", email: "josh@dailydrip.com", password: "secret", password_confirmation: "secret"})
  |> PhoenixRoles.Repo.insert!
