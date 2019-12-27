defmodule GravurWeb.PrintingController do
  use GravurWeb, :controller

  plug GravurWeb.Authorize

  def create(conn, %{"book_id" => book_id}) do
    book = Gravur.Core.get_book_with_greetings(book_id)
    pdf = Gravur.Printing.generate_pdf(book)

    Gravur.Core.update_pdf(book, pdf.url)

    conn
      |> put_resp_content_type("application/pdf")
      |> put_resp_header("content-disposition", "attachment; filename=\"#{pdf.filename}\"")
      |> send_resp(200, pdf.content)
  end
end
