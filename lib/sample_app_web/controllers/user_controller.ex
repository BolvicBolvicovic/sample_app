defmodule SampleAppWeb.UserController do
  use SampleAppWeb, :controller
  alias SampleAppWeb.AuthPlug
  alias SampleApp.Accounts
  alias SampleApp.Accounts.User
  alias Phoenix.HTML.FormData

  plug :logged_in_user when action in [:edit, :update, :index]
  plug :correct_user when action in [:edit, :update]

  def new(conn, _params) do
    changeset = FormData.to_form(Accounts.change_user(%User{}), as: "user")
    render(conn, :new, page_title: "Sign up", user: changeset)
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, :index, users: users)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, %User{} = user} -> 
        conn
        |> AuthPlug.login(user)
        |> put_flash(:info, "Welcome to the Sample App")
        |> redirect(to: ~p"/users/#{user.id}")
      {:error, %Ecto.Changeset{} = changeset} -> render(conn, :new, user: FormData.to_form(changeset, as: "user"))
    end
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = FormData.to_form(Accounts.change_user(user), as: "changeset")
    render(conn, :edit, user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "changeset" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} -> 
        conn
        |> put_flash(:info, "Account successfully updated!")
        |> redirect(to: ~p"/users/#{user.id}")
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, user: user, changeset: FormData.to_form(changeset, as: "changeset"))
    end
  end

end
