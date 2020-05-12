defmodule GravurWeb.PrintingController do
  use GravurWeb, :controller

  plug GravurWeb.Authorize

  def create(conn, %{"book_id" => book_id}) do
    book = Gravur.Core.get_book_with_greetings(book_id)
    pdf = Gravur.Printing.generate_pdf(book)

    json(conn, %{url: pdf.url}) |> IO.inspect()
  end
end
