defmodule SampleAppWeb.SessionControllerTest do
  use SampleAppWeb.ConnCase, async: true
  @base_title "\n     | Phoenix Tutorial Sample App"

  test "should get new", %{conn: conn} do
    conn = get(conn, ~p"/login")

    html_response(conn, 200)
    |> assert_select("title", "Login#{@base_title}")

  end
end
