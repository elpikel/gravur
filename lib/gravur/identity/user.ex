defmodule Gravur.Identity.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :encrypted_password, :string
    field :is_verified, :boolean, default: false
    field :verification_code, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_required([:email], message: "Podaj email.")
    |> unique_constraint(:email, message: "Podany email jest już wykorzystany.")
  end

  @doc false
  def registration_changeset(user, attrs) do
    user
    |> changeset(attrs)
    |> validate_confirmation(:password, message: "Powtórz dwa razy to samo hasło.")
    |> cast(attrs, [:password], [])
    |> validate_length(:password,
      min: 6,
      max: 128,
      message: "Hasło powinno mieć przynajmniej 6 znaków."
    )
    |> random_verification_code()
    |> encrypt_password()
  end

  defp random_verification_code(changeset) do
    verification_code =
      :crypto.strong_rand_bytes(20)
      |> Base.url_encode64()
      |> binary_part(0, 20)

    put_change(changeset, :verification_code, verification_code)
  end

  defp encrypt_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(password))

      _ ->
        changeset
    end
  end
end
