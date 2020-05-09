defmodule Gravur.Utils.FileUploader do
  def upload_book(id, file_name, file_path) do
    path = "uploads/book/#{id}/"
    content = File.read!(file_path)

    upload(path, file_name, content)
  end

  def upload_greeting(book_id, file_name, file_path) do
    path = "uploads/book/#{book_id}/greetings/"
    content = File.read!(file_path)

    upload(path, file_name, content)
  end

  defp upload(path, file_name, content) do
    if Application.get_env(:gravur, :local_storage) do
      upload_local(path, file_name, content)
    else
      upload_aws(path, file_name, content)
    end
  end

  defp upload_aws(path, file_name, content) do
    bucket_name = "#{System.get_env("S3_BUCKET")}/#{path}"
    unique_filename = random_filename(file_name)

    ExAws.S3.put_object(bucket_name, unique_filename, content)
    |> ExAws.request!()

    "https://#{Application.get_env(:ex_aws, :s3)[:host]}/#{bucket_name}#{unique_filename}"
  end

  defp upload_local(path, file_name, content) do
    full_path = "#{path}#{random_filename(file_name)}"

    File.mkdir_p!(Path.dirname(full_path))
    File.write!(full_path, content)

    full_path
  end

  defp random_filename(file_name) do
    (:crypto.strong_rand_bytes(20) |> Base.url_encode64() |> binary_part(0, 20)) <> file_name
  end
end
