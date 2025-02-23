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

  test "successfull edit", %{conn: conn, user: user} do
    name = "Foo Bar"
    email = "foo@bar.com"

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
        name: name,
        email: email,
        password: "long_password",
        password_confirmation: "long_password"
      })

    refute Enum.empty?(conn.assigns.flash)
    assert redirected_to(conn) == ~p"/users/#{user.id}"
    updated_user = Accounts.get_user(user.id)
    assert updated_user.name == name
    assert updated_user.email == email

  end

end
