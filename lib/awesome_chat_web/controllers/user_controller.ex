defmodule AwesomeChatWeb.UserController do
  use AwesomeChatWeb, :controller

  alias AwesomeChat.Accounts
  alias AwesomeChat.Accounts.User

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def login(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "login.html", changeset: changeset)
  end

  def do_login(conn, %{"user" => user_params}) do
    case Accounts.authenticate_user(user_params) do
      {:ok, user} ->
        conn
        |> configure_session(renew: true)
        |> put_session(:authenticated_user, user)
        |> put_flash(:info, "User logged in successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> configure_session(drop: true)
        |> put_flash(:error, "failed to log in.")
        |> render("login.html", changeset: changeset)
    end
  end

  def logout(conn, _) do
    conn
    |> configure_session(drop: true)
    |> put_flash(:info, "logged out successfully.")
    |> redirect(to: user_path(conn, :login))
  end


  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end
end
