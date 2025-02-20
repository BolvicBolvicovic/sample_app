defmodule SampleAppWeb.UserHTML do
  use SampleAppWeb, :html
  
  defp md5_hexdigest(str) do
    :crypto.hash(:md5, str)
    |> Base.encode16(case: :lower)
  end

  def gravatar_for(user) do
    gravatar_id = String.downcase(user.email) |> md5_hexdigest()
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    assigns = %{url: gravatar_url, alt: user.name, class: "gravatar"}
    ~H"""
      <image src={@url} alt={@alt} class={@class} />
    """
  end

  embed_templates "user_html/*"
end
