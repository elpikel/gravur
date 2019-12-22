defmodule Gravu.Utils.ImageTest do
  use ExUnit.Case

  test "generate random filename" do
    name = "filename"
    params = %{"image" => %Plug.Upload{filename: name}}

    params = Gravur.Utils.Image.put_random_filename("image", params)

    assert params["image"].filename != name
  end
end