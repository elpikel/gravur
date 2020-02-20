defmodule Gravu.CoreTest do
  alias Gravur.Repo
  alias Gravur.Identity
  alias Gravur.Core
  alias Gravur.Core.Template

  import Ecto.Query

  use ExUnit.Case

  setup do
    Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    {:ok, user} = Identity.register(%{
      email: "mail@mail.li",
      password: "superstrong",
      password_confirmation: "superstrong"
    })
    {:ok, template} = Template.changeset(
      %Template{},
      %{name: "name", image: "image"})
      |> Repo.insert

     %{user: user, template: template}
  end

  describe "get_all_greetings" do
    test "get all greetings related to book", %{user: user, template: template} do
      book = create_book(user, template)
      greeting = create_greeting(book)

      greetings = Core.get_all_greetings(book.id)
      saved_greeting = Enum.at(greetings, 0)

      assert 1 == length(greetings)

      assert greeting.signature == saved_greeting.signature
      assert greeting.text == saved_greeting.text
      assert greeting.book_id == saved_greeting.book_id
      assert greeting.image == saved_greeting.image
    end

    test "does not get unrelated grretings to book", %{user: user, template: template} do
      book = create_book(user, template)
      unrelated_book = create_book(user, template)
      greeting = create_greeting(book)

      greetings = Core.get_all_greetings(unrelated_book.id)

      assert 0 == length(greetings)
    end
  end

  defp create_book(user, template) do
    {:ok, book} = Core.create_book(%{
      cover_title: "cover_title",
      cover_text: "cover_text",
      font_style: "font_style",
      user_id: user.id,
      template_id: template.id
    })
    book
  end

  defp create_greeting(book) do
    {:ok, greeting} = Core.create_greeting(%{
      "image" => %Plug.Upload{path: "test/fixtures/image.jpg", filename: "image.jpg"},
      "signature" => "signature",
      "text" => "text",
      "book_id" => book.id
    })
    greeting
  end
end