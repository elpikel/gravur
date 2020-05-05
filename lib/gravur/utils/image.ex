defmodule Gravur.Utils.Image do
  def put_random_filename(param_name, params) do
    if Map.has_key?(params, param_name) do
      %{^param_name => %Plug.Upload{filename: name} = image} = params
      image = %Plug.Upload{image | filename: random_filename(name)}
      %{params | param_name => image}
    else
      params
    end
  end

  defp random_filename(name) do
    (:crypto.strong_rand_bytes(20) |> Base.url_encode64() |> binary_part(0, 20)) <> name
  end

  def thumb(img, dimensions) do
    {img, format} =
      ExMagick.init!()
      |> ExMagick.image_load!(img)
      |> (&gen_thumb(&1, ratio(ExMagick.size!(&1), dimensions), dimensions)).()
      |> (&{ExMagick.image_dump!(&1), ExMagick.attr!(&1, :magick)}).()

    {:ok, img, content_type(format)}
  end

  defp gen_thumb(img, _, %{width: width, height: height}),
    do: ExMagick.thumb!(img, width, height)

  defp gen_thumb(img, _, %{width: width, height: height}),
    do: ExMagick.thumb!(img, width, height)

  defp gen_thumb(img, ratio, %{width: width}),
    do: gen_thumb(img, ratio, %{width: width, height: round(width * ratio)})

  defp gen_thumb(img, ratio, %{height: height}),
    do: gen_thumb(img, ratio, %{width: round(height / ratio), height: height})

  defp ratio(dimensions, %{width: _}), do: dimensions.width / dimensions.height

  defp ratio(dimensions, %{height: _}), do: dimensions.height / dimensions.width

  defp content_type(format),
    do: "image/" <> String.downcase(format)
end
