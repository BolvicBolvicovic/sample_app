defmodule SampleAppWeb.StaticPageHTML do
  @moduledoc """
  This module contains pages rendered by StaticPageHTML.

  See the `static_page_html` directory for all templates available.
  """
  use SampleAppWeb, :html

  embed_templates "static_page_html/*"
end
