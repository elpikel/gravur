defmodule Gravur.Core.CoreTest do
  use Gravur.DataCase

  alias Gravur.Identity
  alias Gravur.Core
  alias Gravur.Core.Book
  alias Gravur.Core.Template

  @valid_attrs %{user_id: 1, template_id: 1, cover_text: "cover_text", cover_title: "cover_title", font_style: "font_style", image: %Plug.Upload{path: "test/fixtures/image.jpg", filename: "image.jpg"}}
  @invalid_attrs %{user_id: nil, template_id: nil, cover_text: nil, cover_title: nil, font_style: nil, image: nil}

  setup do
    Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    {:ok, user} = Identity.register(%{ email: "mail@mail.li", password: "superstrong", password_confirmation: "superstrong" })
    {:ok, template} = Template.changeset(%Template{}, %{ name: "name", image: "image" }) |> Repo.insert

    %{user: user, template: template}
  end

  describe "template" do
    test "get_templates/1 get all templates", %{user: _user, template: _template} do
      Template.changeset(%Template{}, %{ name: "name", image: "image" }) |> Repo.insert
      Template.changeset(%Template{}, %{ name: "name", image: "image" }) |> Repo.insert
      Template.changeset(%Template{}, %{ name: "name", image: "image" }) |> Repo.insert

      templates = Core.get_templates()

      assert length(templates) == 4
    end
  end

  describe "greeting" do
    test "get_all_greetings/1 get all greetings related to book", %{user: user, template: template} do
      {:ok, book} = Core.create_book(create_book(@valid_attrs, user, template))
      greeting = create_greeting(book)

      greetings = Core.get_all_greetings(book.id)
      saved_greeting = Enum.at(greetings, 0)

      assert 1 == length(greetings)

      assert greeting.signature == saved_greeting.signature
      assert greeting.text == saved_greeting.text
      assert greeting.book_id == saved_greeting.book_id
      assert greeting.image == saved_greeting.image
    end

    test "get_all_greetings/1 does not get unrelated grretings to book", %{ user: user, template: template } do
      {:ok, book} = Core.create_book(create_book(@valid_attrs, user, template))
      {:ok, unrelated_book} = Core.create_book(create_book(@valid_attrs, user, template))
      _greeting = create_greeting(book)

      greetings = Core.get_all_greetings(unrelated_book.id)

      assert 0 == length(greetings)
    end
  end

  describe "book" do
    test "create_book/1 with valid data creates a book", %{ user: user, template: template } do
      assert {:ok, %Book{} = book} = Core.create_book(create_book(@valid_attrs, user, template))

      assert @valid_attrs.cover_text == book.cover_text
      assert @valid_attrs.cover_title == book.cover_title
      assert @valid_attrs.font_style == book.font_style

      assert user.id == book.user_id
      assert template.id == book.template_id
    end

    test "create_book/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core.create_book(@invalid_attrs)
    end

    test "get_all_books/1 get all books related to user with templates", %{ user: user, template: template } do
      Core.create_book(create_book(@valid_attrs, user, template))
      Core.create_book(create_book(@valid_attrs, user, template))
      Core.create_book(create_book(@valid_attrs, user, template))

      {:ok, new_user} = Identity.register(%{ email: "mail1@mail.li", password: "superstrong", password_confirmation: "superstrong" })
      Core.create_book(create_book(@valid_attrs, new_user, template))
      Core.create_book(create_book(@valid_attrs, new_user, template))

      user_books = Core.get_all_books(user.id)

      assert 3 == length(user_books)
    end

    test "get_book/1 get book", %{ user: user, template: template } do
      {:ok, saved_book} = Core.create_book(create_book(@valid_attrs, user, template))

      book = Core.get_book(saved_book.id)

      assert saved_book.id == book.id

      assert saved_book.cover_text == book.cover_text
      assert saved_book.cover_title == book.cover_title
      assert saved_book.font_style == book.font_style

      assert user.id == book.user_id
      assert template.id == book.template_id
    end

    test "has_book/1 returns true if book exists", %{ user: user, template: template } do
      Core.create_book(create_book(@valid_attrs, user, template))

      has_book = Core.has_book(user.id)

      assert has_book == true
    end

    test "has_book/1 returns false if book does not exist", %{ user: user } do
      has_book = Core.has_book(user.id)

      assert has_book == false
    end

    test "update_pdf/1 updates pdf", %{ user: user, template: template } do
      {:ok, book} = Core.create_book(create_book(@valid_attrs, user, template))

      updated_book = Core.update_pdf(book, "image1.png")

      assert updated_book.id == book.id
      assert updated_book.pdf != book.pdf
    end

    test "get_book_with_greetings/1 returns book without greetings", %{ user: user, template: template } do
      {:ok, book} = Core.create_book(create_book(@valid_attrs, user, template))

      book_with_greetings = Core.get_book_with_greetings(book.id)

      assert length(book_with_greetings.greetings) == 0
    end

    test "get_book_with_greetings/1 returns book with greetings", %{ user: user, template: template } do
      {:ok, book} = Core.create_book(create_book(@valid_attrs, user, template))
      create_greeting(book)
      create_greeting(book)
      create_greeting(book)

      book_with_greetings = Core.get_book_with_greetings(book.id)

      assert length(book_with_greetings.greetings) == 3
    end
  end

  defp create_book(book, user, template) do
    book = %{ book | user_id: user.id }
    %{ book | template_id: template.id }
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