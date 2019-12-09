defmodule Gravur.Guest do
  alias Gravur.Repo
  alias Gravur.Guest.Greeting

  import Ecto.Query

  def get_all_greetings(book_id) do
    Greeting |> where(book_id: ^book_id) |> Repo.all
  end

  def create_greeting(greeting_params) do
    Greeting.changeset(%Greeting{}, greeting_params) |> Repo.insert()
  end
end