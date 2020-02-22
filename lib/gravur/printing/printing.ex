defmodule Gravur.Printing do
  defstruct filename: "", content: "", url: ""

  def generate_pdf(book) do
    html = generate_html(book)

    IO.inspect(html)
    {:ok, filename} = PdfGenerator.generate(html, page_size: "A5")
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
  end

  defp generate_html(book) do
    EEx.eval_file(
      Path.join(:code.priv_dir(:gravur), "templates/general.html.eex"),
      greetings: book.greetings)
  end
end