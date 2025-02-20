defmodule SampleApp.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SampleApp.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(_attrs \\ %{}) do
    
    #{:ok, user} = SampleApp.Accounts.create_user(attrs)

    %{SampleApp.Factory.insert(:user) | password: nil, password_confirmation: nil}
  end

end
