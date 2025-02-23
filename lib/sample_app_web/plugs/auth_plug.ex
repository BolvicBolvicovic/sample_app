defmodule SampleAppWeb.AuthPlug do
  import Plug.Conn
  alias SampleApp.Token
  alias SampleApp.Accounts
  import Phoenix.Controller
  use SampleAppWeb, :verified_routes

  @cookie_max_age 630_720_000 # 20 years in second

  def init(opts), do: opts

  def call(conn, _opts) do
    cond do
      conn.assigns[:current_user] -> conn
      user_id = get_session(conn, :user_id) ->
        user = Accounts.get_user(user_id)
        assign(conn, :current_user, user)
      token = conn.cookies["remember_token"] ->
        case Token.verify_remember_token(token) do
          {:ok, user_id} -> 
            if user = Accounts.get_user(user_id) do
              login(conn, user)
            else
              logout(conn)
            end
          {:error, _reason} -> logout(conn)
        end
      true -> assign(conn, :current_user, nil)
    end
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def logout(conn) do
    conn
    |> delete_resp_cookie("remember_token")
    |> configure_session(drop: true)
    |> assign(:current_user, nil)
  end

  def remember(conn, user) do
    token = SampleApp.Token.gen_remember_token(user)
    put_resp_cookie(conn, "remember_token", token, max_age: @cookie_max_age)
  end

  def logged_in_user(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "Please log in.")
      |> redirect(to: ~p"/login")
      |> halt()
    end
  end

  def correct_user(conn, _opts) do
    user_id = String.to_integer(conn.params["id"])

    unless user_id == conn.assigns.current_user.id do
      conn
      |> put_flash(:error, "Not allowed!")
      |> redirect(to: ~p"/")
      |> halt()
    else
      conn
    end
  end


end
