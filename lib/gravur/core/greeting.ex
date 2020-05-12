defmodule Gravur.Core.Greeting do
  use Ecto.Schema

  import Ecto.Changeset

  schema "greetings" do
    field :image, :string
    field :signature, :string
    field :text, :string

    belongs_to :book, Gravur.Core.Book, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(greeting, attrs) do
    greeting
    |> cast(attrs, [:text, :signature, :book_id, :image])
    |> validate_required([:text, :signature, :book_id])
  end

  def image_url(greeting, size \\ "") do
    if Application.get_env(:gravur, :local_storage) do
      "/uploads/book/#{greeting.book_id}/greetings/#{greeting.id}/#{size}#{greeting.image}"
    else
      "#{System.get_env("S3_BUCKET")}/uploads/book/#{greeting.book_id}/greetings/#{greeting.id}/#{
        subpath(size)
      }#{greeting.image}"
    end
  end

  defp subpath(""), do: ""
  defp subpath(path), do: "#{path}/"

  def image_small_url(greeting) do
    image_url(greeting, "400_400")
  end

  def image_path(greeting, size \\ "") do
    if Application.get_env(:gravur, :local_storage) do
      "uploads/book/#{greeting.book_id}/greetings/#{greeting.id}/#{size}"
    else
      "#{System.get_env("S3_BUCKET")}/uploads/book/#{greeting.book_id}/greetings/#{greeting.id}/#{
        size
      }"
    end
  end

  def image_small_path(greeting) do
    image_path(greeting, "400_400")
  end
end
