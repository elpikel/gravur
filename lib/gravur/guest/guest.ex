defmodule Gravur.Guest do
  alias Gravur.Repo
  alias Gravur.Guest.Greeting

  def get_all_greetings(user) do
    # user = Repo.preload(user, :books)
    # user.books
  end

  def create_greeting(greeting_params) do
    Greeting.changeset(%Greeting{}, greeting_params) |> Repo.insert()
  end
end