defmodule Gravur.Printing do
  defstruct filename: "", content: "", url: ""

  def generate_pdf(book) do
    html = generate_html(book)

    # {:ok, filename} = PdfGenerator.generate(html, page_size: "A5")
    {:ok, filename} = PdfGenerator.generate {:url, "http://google.com"}, page_size: "A5"
    {:ok, content} = File.read(filename)
    {:ok, url} = Gravur.Utils.BookPdf.store({ filename, book })

    %Gravur.Printing{filename: filename, content: content, url: url}
  end

  def get_image_url(greeting) do
    url = Gravur.Utils.GreetingImage.url({ greeting.image, greeting })

    if String.starts_with?(url, "https:") do
      url
    else
      "http://localhost:4000" <> url
    end

    "https://gravur.s3.amazonaws.com/uploads/book/0c997136-ac1f-4cdd-ba2d-deaaf25bfd19/greetings/fLEACvsQiQ-xB2NS6psGjakub-sejkora-42069-unsplash.jpg?v=63749523978"
  end

  defp generate_html(book) do
    EEx.eval_file(
      Path.join(:code.priv_dir(:gravur), "templates/general.html.eex"),
      greetings: book.greetings)
  end
end