defmodule SampleAppWeb.StaticPageControllerTest do
  use SampleAppWeb.ConnCase

  @base_title "\n     | Phoenix Tutorial Sample App"

  test "should get home", %{conn: conn} do
    conn = get(conn, ~p"/")
    html_response(conn, 200)
    |> assert_select("title", "Home#{@base_title}")
  end

  test "should get help", %{conn: conn} do
    conn = get(conn, ~p"/help")
    html_response(conn, 200)
    |> assert_select("title", "Help#{@base_title}")
  end

  test "should get about", %{conn: conn} do
    conn = get(conn, ~p"/about")
    assert html_response(conn, 200)
    html_response(conn, 200)
    |> assert_select("title", "About#{@base_title}")
  end

  test "should get contact", %{conn: conn} do
    conn = get(conn, ~p"/contact")
    assert html_response(conn, 200)
    html_response(conn, 200)
    |> assert_select("title", "Contact#{@base_title}")
  end

end
