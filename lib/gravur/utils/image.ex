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

  def scale(original, preferred) do
    ratio_w = ratio(original.width, preferred.width)
    ratio_h = ratio(original.height, preferred.height)
    ratio = if ratio_w > ratio_h, do: ratio_h, else: ratio_w

    %{width: trunc(original.width * ratio), height: trunc(original.height * ratio)}
  end

  defp ratio(original, preferred) do
    cond do
      original > preferred -> preferred / original
      original < preferred -> original / preferred
      true -> 1
    end
  end

  def thumb(img, dimensions) do
    {img, format} =
      ExMagick.init!()
      |> ExMagick.image_load!(img)
      |> (&thumb!(&1, scale(ExMagick.size!(&1), dimensions))).()
      |> (&{ExMagick.image_dump!(&1), ExMagick.attr!(&1, :magick)}).()

    {:ok, img, content_type(format)}
  end

  defp thumb!(img, %{width: width, height: height}),
    do: ExMagick.thumb!(img, width, height)

  defp content_type(format),
    do: "image/" <> String.downcase(format)
end
