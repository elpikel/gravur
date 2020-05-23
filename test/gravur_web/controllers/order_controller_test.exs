defmodule GravurWeb.OrderControllerTest do
  use GravurWeb.ConnCase

  alias Gravur.Repo
  alias Gravur.Core
  alias Gravur.Core.Book
  alias Gravur.Core.Template

  setup do
    {:ok, user} =
      Gravur.Identity.register(%{
        email: "email@email.com",
        password: "password",
        password_confirmation: "password"
      })

    {:ok, template} =
      Template.changeset(%Template{}, %{
        name: "name",
        image: "image",
        cover: "cover",
        html: "html"
      })
      |> Repo.insert()

    {:ok, book} =
      Core.create_book(%{
        cover_text: "cover_text",
        cover_title: "cover_title",
        font_style: "font_style",
        image: %Plug.Upload{path: "test/fixtures/image.jpg", filename: "image.jpg"},
        user_id: user.id,
        template_id: template.id
      })

    conn = Plug.Test.init_test_session(build_conn(), user_id: user.id)

    {:ok, %{conn: conn, book: book}}
  end

  test "shows order page", %{conn: conn, book: book} do
    conn = get(conn, Routes.book_order_path(conn, :new, book.id))
    assert html_response(conn, 200) =~ "Dane i dostawa"
  end

  test "creates order page", %{conn: conn, book: book} do
    conn =
      post(conn, Routes.book_order_path(conn, :create, book.id), %{
        "order" => %{
          "name" => "name",
          "address1" => "address1",
          "address2" => "address2",
          "items" => "1"
        },
        "book_id" => book.id
      })

    assert html_response(conn, 302) =~ "redirected"
    assert Repo.get(Book, book.id) == book
  end
end
