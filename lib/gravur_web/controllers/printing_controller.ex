defmodule GravurWeb.PrintingController do
  use GravurWeb, :controller

  def create(conn, %{"book_id" => book_id}) do
    html = "<html><body><p>Hi there!</p></body></html>"
    # be aware, this may take a while...
    {:ok, filename}    = PdfGenerator.generate(html, page_size: "A5")
    {:ok, pdf_content} = File.read(filename)
    File.write("/Users/arkadiuszplichta/Repositories/test.pdf", pdf_content)

    conn
      |> put_resp_content_type("application/pdf")
      |> put_resp_header(
        "content-disposition",
        "attachment; filename=\"#{filename}\"")
      |> send_resp(200, pdf_content)
  end
end
