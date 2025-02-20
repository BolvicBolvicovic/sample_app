defmodule SampleAppWeb.StaticPageController do
  use SampleAppWeb, :controller

  def home(conn, _params), do: render(conn, :home, page_title: "Home")

  def help(conn, _params), do: render(conn, :help, page_title: "Help")

  def about(conn, _params), do: render(conn, :about, page_title: "About")

  def contact(conn, _params), do: render(conn, :contact, page_title: "Contact")

end
