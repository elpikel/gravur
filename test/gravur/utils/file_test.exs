defmodule Gravur.Utils.FileTest do
  use ExUnit.Case

  test "uploads book to local storage" do
    content = "content"
    File.write("tmp_book", content)
    file_path = Gravur.Utils.File.upload_book(1, "book.jpg", "tmp_book")

    assert File.read!(file_path) == content

    File.rm(file_path)
    File.rm("tmp_book")
  end

  test "uploads greeting to local storage" do
    content = "content"
    File.write("tmp_greeting", content)

    file_path = Gravur.Utils.File.upload_greeting(1, "greeting.jpg", "tmp_greeting")

    assert File.read!(file_path) == content

    File.rm(file_path)
    File.rm("tmp_book")
  end

  test "uploads file to aws" do
  end
end
