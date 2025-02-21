defmodule SampleAppWeb.UserSignupTest do
  use SampleAppWeb.ConnCase, async: true

  test "invalid signup information", %{conn: conn} do
    default_count_error_handlers = 2
    user_record_before = Repo.one(from u in User, select: count())

    conn = conn
    |> get(~p"/signup")
    |> post(~p"/users", %{
      user: %{
        name: "",
        email: "user@invalid",
        password: "foo",
        password_confirmation: "bar"
      }
    })

    user_record_after = Repo.one(from u in User, select: count())
    assert user_record_before == user_record_after
    html_response(conn, 200)
    |> assert_select("span.hero-exclamation-circle-mini", count: 4 + default_count_error_handlers)

  end

  test "valid signup information", %{conn: conn} do
    user_email = "user@example.com"
    user_record_before = Repo.one(from u in User, select: count())

    conn =
      conn
      |> get(~p"/signup")
      |> post(~p"/users", %{
        user: %{
          name: "Example User",
          email: user_email,
          password: "foobarbar",
          password_confirmation: "foobarbar"
        }
      })

    user_record_after = Repo.one(from u in User, select: count())
    assert user_record_before + 1 == user_record_after
    user = Repo.get_by(User, email: user_email)
    assert redirected_to(conn) == ~p"/users/#{user.id}"
    refute Enum.empty?(conn.assigns.flash)
    conn = get(conn, redirected_to(conn))
    assert is_logged_in?(conn)
    html_response(conn, 200)
    

  end

end
