defmodule Gravur.Utils.Image do
  def put_random_filename(param_name, params) do
    %{^param_name => %Plug.Upload{filename: name} = image} = params
    image = %Plug.Upload{image | filename: random_filename(name)}
    %{params | param_name => image}
  end

  defp random_filename(name) do
    (:crypto.strong_rand_bytes(20) |> Base.url_encode64 |> binary_part(0, 20)) <> name
  end
end