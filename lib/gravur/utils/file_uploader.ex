defmodule Gravur.Utils.FileUploader do
  def upload_book(book, content) do
    path = Gravur.Core.Book.pdf_path(book)

    upload(path, book.pdf, content)
  end

  def upload_greeting(greeting, content) do
    path = Gravur.Core.Greeting.image_path(greeting)

    upload(path, greeting.image, content)
  end

  def upload_greeting_small(greeting, content) do
    path = Gravur.Core.Greeting.image_small_path(greeting)

    upload(path, greeting.image, content)
  end

  def upload_greeting_medium(greeting, content) do
    path = Gravur.Core.Greeting.image_medium_path(greeting)

    upload(path, greeting.image, content)
  end

  defp upload(path, file_name, content) do
    if Application.get_env(:gravur, :local_storage) do
      upload_local(path, file_name, content)
    else
      upload_aws(path, file_name, content)
    end
  end

  defp upload_aws(path, file_name, content) do
    ExAws.S3.put_object(path, file_name, content)
    |> ExAws.request!()

    "#{path}#{file_name}"
  end

  defp upload_local(path, file_name, content) do
    full_path = "#{path}#{file_name}"

    File.mkdir_p!(Path.dirname(full_path))
    File.write!(full_path, content)

    full_path
  end
end
