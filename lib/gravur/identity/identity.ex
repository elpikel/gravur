defmodule Gravur.Identity do
  alias Ecto.Changeset
  alias Gravur.Repo
  alias Gravur.Identity.User

  def sign_in(email, password) do
    user = Repo.get_by(User, email: email)

    cond do
      user && user.is_verified && Comeonin.Bcrypt.checkpw(password, user.encrypted_password) ->
        {:ok, user}

      true ->
        {:error, :unauthorized}
    end
  end

  def get_user(user_id) do
    Repo.get(User, user_id)
  end

  def current_user(conn) do
    user_id = Plug.Conn.get_session(conn, :user_id)
    if user_id, do: Repo.get(User, user_id)
  end

  def current_user_id(conn) do
    Plug.Conn.get_session(conn, :user_id)
  end

  def user_signed_in?(conn) do
    !!Plug.Conn.get_session(conn, :user_id)
  end

  def sign_out(conn) do
    Plug.Conn.configure_session(conn, drop: true)
  end

  def register(params) do
    User.registration_changeset(%User{}, params) |> Repo.insert()
  end

  def verify(user_id, verification_code) do
    user = Repo.get(User, user_id)

    cond do
      user && user.verification_code == verification_code ->
        user
        |> Changeset.change(%{is_verified: true})
        |> Repo.update()

      true ->
        {:error, "wrong verification code"}
    end
  end
end
