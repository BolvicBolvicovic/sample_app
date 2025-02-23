defmodule SampleAppWeb.UserControllerTest do
  use SampleAppWeb.ConnCase, async: true

  setup do
    {:ok, user: Factory.insert(:user), other_user: Factory.insert(:user)}
  end

  test "should get new", %{conn: conn} do
    conn = get(conn, ~p"/signup")
    assert html_response(conn, 200)
  end
  
  test "should redirect edit when not logged in", %{conn: conn, user: user} do
    conn = get(conn, ~p"/edit/#{user.id}")

    refute Enum.empty?(conn.assigns.flash)
    assert redirected_to(conn, 302) == ~p"/login"
  end

  test "should redirect update when not logged in", %{conn: conn, user: user} do
    conn = put(conn, ~p"/users/#{user.id}", %{user: %{name: user.name, email: user.email}})

    refute Enum.empty?(conn.assigns.flash)
    assert redirected_to(conn, 302) == ~p"/login"
  end
  
  test "should redirect edit when logged in as wrong user",
       %{conn: conn, user: user, other_user: other_user} do
    conn =
      conn
      |> get(~p"/login")
      |> post(~p"/login", %{
        login: %{
          email: other_user.email,
          password: "long_password",
          remember_me: "false"
        }})
      |> get(~p"/edit/#{user.id}")

    assert redirected_to(conn, 302) == ~p"/"
  end

  test "should redirect update when logged in as wrong user",
       %{conn: conn, user: user, other_user: other_user} do
    conn =
      conn
      |> get(~p"/login")
      |> post(~p"/login", %{
        login: %{
          email: other_user.email,
          password: "long_password",
          remember_me: "false"
        }})
      |> put(~p"/users/#{user.id}", %{
          user: %{
            name: user.name,
            email: user.email
        }})

    assert redirected_to(conn, 302) == ~p"/"
  end

end
