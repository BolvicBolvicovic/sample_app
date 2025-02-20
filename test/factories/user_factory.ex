defmodule SampleApp.UserFactory do
  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %SampleApp.Accounts.User{
          name: sequence(:name, &"Example User#{&1}"),
          email: sequence(:email, &"user-#{&1}@example.com"),
          password: "long_password",
          password_confirmation: "long_password",
          password_hash: Argon2.hash_pwd_salt("long_password")
        }
      end
    end
  end
end
