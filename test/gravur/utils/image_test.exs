defmodule Gravu.Utils.ImageTest do
  use ExUnit.Case

  test "generate random filename" do
    name = "filename"
    params = %{"image" => %Plug.Upload{filename: name}}

    params = Gravur.Utils.Image.put_random_filename("image", params)

    assert params["image"].filename != name
  end

  describe "thumb/2" do
    test "generates the same when is equal" do
      original = %{width: 400, height: 400}
      preferred = %{width: 400, height: 400}

      scaled = Gravur.Utils.Image.scale(original, preferred)

      assert %{width: 400, height: 400} == scaled
    end

    test "generates smaller with the same ratio" do
      original = %{width: 800, height: 800}
      preferred = %{width: 200, height: 200}

      scaled = Gravur.Utils.Image.scale(original, preferred)

      assert %{width: 200, height: 200} == scaled
    end

    test "scales with ratio based on width" do
      original = %{width: 8000, height: 4000}
      preferred = %{width: 400, height: 400}

      scaled = Gravur.Utils.Image.scale(original, preferred)

      assert %{width: 400, height: 200} == scaled
    end

    test "scales with ratio based on height" do
      original = %{width: 4000, height: 8000}
      preferred = %{width: 400, height: 400}

      scaled = Gravur.Utils.Image.scale(original, preferred)

      assert %{width: 200, height: 400} == scaled
    end
  end
end
