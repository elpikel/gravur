defmodule Gravur.Utils.Image do
  def random_filename(name) do
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
    try do
      with {:ok, handler} <- ExMagick.init(),
           {:ok, loaded_image} <- ExMagick.image_load(handler, {:blob, img}),
           {:ok, size} <- ExMagick.size(loaded_image),
           thumb_size <- scale(size, dimensions),
           {:ok, thumb} <- ExMagick.thumb(loaded_image, thumb_size.width, thumb_size.height),
           {:ok, image_dump} <- ExMagick.image_dump(thumb) do
        image_dump
      else
        {:error, _} ->
          nil
      end
    catch
      _ ->
        nil
    end
  end
end
