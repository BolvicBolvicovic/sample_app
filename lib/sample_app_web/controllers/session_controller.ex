defmodule SampleAppWeb.SessionController do
  use SampleAppWeb, :controller
  alias SampleAppWeb.AuthPlug
  alias SampleApp.Accounts.User
  alias SampleApp.Accounts
  alias Phoenix.HTML.FormData

  def new(conn, _params) do
    changeset = 
      Accounts.change_user(%User{})
      |> FormData.to_form(as: "login")
    
    render(conn, :new, page_title: "Login", login: changeset)
  end

  def create(conn, %{"login" => login}) do
    case Accounts.authentificate_by_email_and_pass(login["email"], login["password"]) do
      {:ok, user} ->
        conn
        |> AuthPlug.login(user)
        |> put_flash(:info, "You are now connected")
        |> redirect(to: ~p"/users/#{user.id}")
      {:error, _} ->
        conn
        |> put_flash(:error, "Incorrect email/password")
        |> redirect(to: ~p"/login")
        
    end
  end

  def delete(conn, _params) do
    conn
    |> AuthPlug.logout()
    |> redirect(to: ~p"/")
  end
end
