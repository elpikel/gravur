defmodule Gravur.Printing do
  defstruct filename: "", content: "", url: ""

  def generate_pdf(book) do
    html = generate_html(book)

    {:ok, filename} =
      PdfGenerator.generate(html,
        shell_params: [
          "--page-height",
          "216mm",
          "--page-width",
          "216mm"
        ]
      )

    {:ok, content} = File.read(filename)

    filename = Gravur.Utils.Image.random_filename("#{book.id}.pdf")
    book = Gravur.Core.update_pdf(book, filename)

    url = Gravur.Utils.FileUploader.upload_book(book, content)

    %Gravur.Printing{filename: filename, content: content, url: url}
  end

  def get_image_url(greeting) do
    url = Gravur.Core.Greeting.image_url(greeting)

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
