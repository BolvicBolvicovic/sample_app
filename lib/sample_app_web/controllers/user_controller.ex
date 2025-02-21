defmodule SampleAppWeb.UserController do
  use SampleAppWeb, :controller
  alias SampleAppWeb.AuthPlug
  alias SampleApp.Accounts
  alias SampleApp.Accounts.User
  alias Phoenix.HTML.FormData

  def new(conn, _params) do
    changeset = FormData.to_form(Accounts.change_user(%User{}), as: "user")
    render(conn, :new, page_title: "Sign up", user: changeset)
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
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

end
