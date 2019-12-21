defmodule GravurWeb.PrintingController do
  use GravurWeb, :controller

  plug GravurWeb.Authorize

  def create(conn, %{"book_id" => book_id}) do
    book = Gravur.Core.get_book_with_greetings(book_id)
    html = generate_html(book)

    {:ok, filename} = PdfGenerator.generate(html, page_size: "A5")
    {:ok, pdf_content} = File.read(filename)

    {:ok, stored_pdf} = Gravur.Utils.Upload.store({ filename, book })
    Gravur.Core.update_pdf(book, stored_pdf)

    conn
      |> put_resp_content_type("application/pdf")
      |> put_resp_header("content-disposition", "attachment; filename=\"#{filename}\"")
      |> send_resp(200, pdf_content)
  end

  defp generate_html(book) do
    greetings = book.greetings
     |> Enum.map(fn greeting -> "<li><img width=\"500\" src=\"#{get_image_url(greeting)}\" /><div>#{greeting.text}</div><div>#{greeting.signature}</div></li>" end)

    "<html><body><p><ul style=\"list-style-type:none;\">#{greetings}</ul</p></body></html>"
  end

  defp get_image_url(greeting) do
    url = Gravur.Utils.Upload.url({ greeting.image, greeting })

    if String.starts_with?(url, "https:") do
      url
    else
      "http://localhost:4000" <> url
    end
  end
end
