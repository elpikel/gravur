defmodule Gravur.Printing do
  defstruct filename: "", content: "", url: ""

  def generate_pdf(book) do
    html = generate_html(book)

    {:ok, filename} =
      PdfGenerator.generate(html, page_size: "Custom(Millimeters(200), Millimeters(200))")

    {:ok, content} = File.read(filename)
    {:ok, url} = Gravur.Utils.BookPdf.store({filename, book})

    %Gravur.Printing{filename: filename, content: content, url: url}
  end

  def get_image_url(greeting) do
    url = Gravur.Utils.GreetingImage.url({greeting.image, greeting})

    # small hack for heroku and https
    if String.starts_with?(url, "https:") do
      String.replace(url, "https", "http")
    else
      "http://localhost:4000" <> url
    end
  end

  defp generate_html(book) do
    EEx.eval_file(
      Path.join(:code.priv_dir(:gravur), book.template.html),
      greetings: book.greetings,
      template: book.template
    )
  end
end
