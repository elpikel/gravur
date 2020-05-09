defmodule Gravur.Utils.FileUploaderTest do
  use ExUnit.Case

  alias Gravur.Utils.FileUploader

  test "uploads book to local storage" do
    content = "content"
    File.write("tmp_book", content)
    file_path = FileUploader.upload_book(1, "book.jpg", "tmp_book")

    assert File.read!(file_path) == content

    File.rm(file_path)
    File.rm("tmp_book")
  end

  test "uploads greeting to local storage" do
    content = "content"
    File.write("tmp_greeting", content)

    file_path = FileUploader.upload_greeting(1, "greeting.jpg", "tmp_greeting")

    assert File.read!(file_path) == content

    File.rm(file_path)
    File.rm("tmp_greeting")
  end

  @tag :skip
  test "uploads file to aws" do
    Application.put_env(:gravur, :local_storage, false)
    content = "content"
    File.write("tmp_greeting", content)

    FileUploader.upload_greeting(1, "greeting.jpg", "tmp_greeting")
  end
end
