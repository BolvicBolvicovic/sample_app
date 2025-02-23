defmodule SampleAppWeb.UserEditTest do
  use SampleAppWeb.ConnCase, async: true
  setup do
    {:ok, user: Factory.insert(:user)}
  end

  test "unsuccessfull edit", %{conn: conn, user: user} do
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
      |> get(~p"/edit/#{user.id}")

    html_response(conn, 200)
    |> assert_select("form[action='/users/#{user.id}']")

    conn =
      put(conn, ~p"/users/#{user.id}", changeset: %{
        name: "",
        email: "foo@invalid",
        password: "foo",
        password_confirmation: "bar"
      })

    html_response(conn, 200)
    |> assert_select("form[action='/users/#{user.id}']")

  end

end
