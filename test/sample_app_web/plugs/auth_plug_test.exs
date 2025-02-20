defmodule SampleAppWeb.AuthPlugTest do
  use SampleAppWeb.ConnCase
  alias SampleAppWeb.AuthPlug

  setup %{conn: conn} do
    conn =
      conn
      |> bypass_through(SampleAppWeb.Router, :browser)
      |> get("/")

    {:ok, conn: conn}
  end

  describe "call/2" do
    test "places user from session into assigns as current_user", %{conn: conn} do
      user = Factory.insert(:user)

      conn =
        conn
        |> put_session(:user_id, user.id)
        |> AuthPlug.call(AuthPlug.init([]))

      assert conn.assigns.current_user.id == user.id
    end

    test "with no session sets current_user assign to nil", %{conn: conn} do
      conn = AuthPlug.call(conn, AuthPlug.init([]))
      assert conn.assigns.current_user == nil
    end
  end

  describe "login/2" do
    test "puts the user id in the session", %{conn: conn} do
      user = Factory.insert(:user)
      login_conn =
        conn
        |> AuthPlug.login(%User{id: user.id})
        |> send_resp(:ok, "")
      next_conn = get(login_conn, "/")
      assert get_session(next_conn, :user_id) == user.id
    end
  end

end
