defmodule Gravur.Utils.Image do
  def put_random_filename(%{"image" => %Plug.Upload{filename: name} = image} = params) do
    image = %Plug.Upload{image | filename: random_filename(name)}
    %{params | "image" => image}
  end

  def put_random_filename(%{"title_page_image" => %Plug.Upload{filename: name} = image} = params) do
    image = %Plug.Upload{image | filename: random_filename(name)}
    %{params | "title_page_image" => image}
  end

  def put_random_filename(params), do: params

  defp random_filename(name) do
    (:crypto.strong_rand_bytes(20) |> Base.url_encode64 |> binary_part(0, 20)) <> name
  end
end