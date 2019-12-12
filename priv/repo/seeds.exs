# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Gravur.Repo.insert!(%Gravur.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Gravur.Repo.insert!(%Gravur.Core.Template{name: "wzór drzewny", image: "/images/one.jpg"})
Gravur.Repo.insert!(%Gravur.Core.Template{name: "wzór kwiatowy", image: "/images/two.jpg"})