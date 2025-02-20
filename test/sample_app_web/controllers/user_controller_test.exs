defmodule SampleAppWeb.UserControllerTest do
  use SampleAppWeb.ConnCase, async: true

  test "should get new", %{conn: conn} do
    conn = get(conn, ~p"/signup")
    assert html_response(conn, 200)
  end
end
