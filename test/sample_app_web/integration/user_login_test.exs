defmodule SampleAppWeb.Integration.UserLoginTest do
  use SampleAppWeb.ConnCase, async: true

  setup do
    {:ok, user: Factory.insert(:user)}
  end

  test "login with invalid information", %{conn: conn, user: user} do
    conn = 
      conn
      |> get(~p"/login")
      |> post(~p"/login", %{
        login: %{
          email: user.email,
          password: "wrong_password",
          remember_me: "false"
        }
      })

    refute is_logged_in?(conn)
    assert redir_path =
      redirected_to(conn) == ~p"/login"
    conn = get(recycle(conn), redir_path)
    html_response(conn, 200)
    |> assert_select("a[href='#{~p"/login"}']")
    |> refute_select("a[href='#{~p"/logout"}']")
    |> refute_select("a[href='#{~p"/users/#{user.id}"}']")
  end

  test "login with valid information", %{conn: conn, user: user} do
    conn =
      conn
      |> get(~p"/login")
      |> post(~p"/login", %{
        login: %{
          email: user.email,
          password: "long_password",
          remember_me: "false"
        }
      })
    assert is_logged_in?(conn)
    assert redir_path =
      redirected_to(conn) == ~p"/users/#{user.id}"
    conn = get(recycle(conn), redir_path)

    html_response(conn, 200)
    |> refute_select("a[href='#{~p"/login"}']")
    |> assert_select("a[href='#{~p"/logout"}']")
    |> assert_select("a[href='#{~p"/users/#{user.id}"}']")
  end

  test "login with valid information followed by logout",
       %{conn: conn, user: user} do
    conn =
      conn
      |> get(~p"/login")
      |> post(~p"/login", %{
        login: %{
          email: user.email,
          password: "long_password",
          remember_me: "false"
        }
      })

    assert is_logged_in?(conn)

    assert redir_path =
             redirected_to(conn) == ~p"/users/#{user.id}"

    conn = get(recycle(conn), redir_path)

    html_response(conn, 200)
    |> refute_select("a[href='#{~p"/login"}']")
    |> assert_select("a[href='#{~p"/logout"}']")
    |> assert_select("a[href='#{~p"/users/#{user.id}"}']")

    conn = delete(conn, ~p"/logout")
    refute is_logged_in?(conn)
    assert redir_path = redirected_to(conn) == ~p"/"
    conn = get(recycle(conn), redir_path)

    html_response(conn, 200)
    |> assert_select("a[href='#{~p"/login"}']")
    |> refute_select("a[href='#{~p"/logout"}']")
    |> refute_select("a[href='#{~p"/users/#{user.id}"}']")
  end
end
