defmodule GravurWeb.PrintingController do
  use GravurWeb, :controller

  plug GravurWeb.Authorize

  def create(conn, %{"book_id" => book_id}) do
    book = Gravur.Core.get_book_with_greetings(book_id)
    pdf = Gravur.Printing.generate_pdf(book)

    Gravur.Core.update_pdf(book, pdf.url)

    json(conn, %{url: Gravur.Utils.BookPdf.url({ pdf.url, book })})
  end
end
