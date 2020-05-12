defmodule Gravur.Utils.FileUploaderTest do
  use ExUnit.Case

  alias Gravur.Core.Book
  alias Gravur.Core.Greeting
  alias Gravur.Utils.FileUploader

  test "uploads book to local storage" do
    content = "content"
    File.write("tmp_book", content)
    file_path = FileUploader.upload_book(%Book{id: 1, pdf: "1.pdf"}, content)

    assert File.read!(file_path) == content

    File.rm(file_path)
    File.rm("tmp_book")
  end

  test "uploads greeting to local storage" do
    content = "content"
    File.write("tmp_greeting", content)

    file_path =
      FileUploader.upload_greeting(
        %Greeting{id: 1, book_id: 1, image: "greeting.jpg"},
        content
      )

    assert File.read!(file_path) == content

    File.rm(file_path)
    File.rm("tmp_greeting")
  end

  @tag :skip
  test "uploads file to aws" do
    Application.put_env(:gravur, :local_storage, false)
    content = "content"
    File.write("tmp_greeting", content)

    FileUploader.upload_greeting(
      %Greeting{id: 1, book_id: 1, image: "greeting.jpg"},
      content
    )
  end
end
