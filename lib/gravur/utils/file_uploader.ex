defmodule Gravur.Utils.FileUploader do
  """
  uploads file to:
  /book/id/
  /book/id/greetings/
  """

  def upload_book(id, file_name, file_path) do
    path = "uploads/book/#{id}/#{random_filename(file_name)}"
    content = File.read!(file_path)

    upload(path, content)
  end

  def upload_greeting(book_id, file_name, file_path) do
    path = "uploads/book/#{book_id}/greetings/#{random_filename(file_name)}"
    content = File.read!(file_path)

    upload(path, content)
  end

  defp upload(path, content) do
    upload(Application.get_env(:gravur, :local_storage), path, content)
  end

  defp upload(false, path, content) do
  end

  defp upload(_, path, content) do
    File.mkdir_p!(Path.dirname(path))
    File.write!(path, content)
    path
  end

  defp random_filename(file_name) do
    (:crypto.strong_rand_bytes(20) |> Base.url_encode64() |> binary_part(0, 20)) <> file_name
  end
end
