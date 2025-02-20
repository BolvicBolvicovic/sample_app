defmodule SampleApp.AccountsTest do
  use SampleApp.DataCase

  alias SampleApp.Accounts
  alias SampleApp.Accounts.User
  alias SampleApp.Factory

  import SampleApp.AccountsFixtures

  describe "users" do

    @invalid_attrs %{name: nil, email: nil}
    @valid_attrs %{name: "Example User", email: "user@example.com", password: "foobarbar", password_confirmation: "foobarbar"}

    test "list_users/0 returns all users" do
      user = user_fixture()
      user2 = user_fixture()
      assert Accounts.list_users() == [user, user2]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do

      valid_addresses = ~w(USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn)

      Enum.each(valid_addresses, fn addr -> 
        assert {:ok, %User{}} = Accounts.create_user(%{@valid_attrs | email: addr}) 
      end)

      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.name == "Example User"
      assert user.email == "user@example.com"
    end

    test "create_user/1 with invalid data returns error changeset" do

      invalid_adresses = ~w(user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com foo@bar..com)

      Enum.each(invalid_adresses, fn addr -> 
        assert {:error, %Ecto.Changeset{}} = Accounts.create_user(%{@valid_attrs | email: addr})
      end)

      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "create_user/1 with already existing email adress (case insensitive) -> respond with error" do
      Factory.insert(:user, @valid_attrs) 
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(%{@valid_attrs | email: String.upcase(@valid_attrs[:email])})
    end
  

    test "update_user/2 with valid data updates the user" do
      user = user_fixture(@valid_attrs)

      assert {:ok, %User{} = user} = Accounts.update_user(user, @valid_attrs)
      assert user.name == @valid_attrs[:name]
      assert user.email == @valid_attrs[:email]
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "authentification" do
    @email "user@example.com"
    @pass "12345678"

    setup do
      {:ok,
       user:
        Factory.insert(:user,
          email: @email,
          password: @pass,
          password_hash: Argon2.hash_pwd_salt(@pass)
      )}
    end

    test "return user with correct password", %{user: %User{id: id}} do
      assert {:ok, %User{id: ^id}} = Accounts.authentificate_by_email_and_pass(@email, @pass)
    end

    test "return unauthorized error with invalid password" do
      assert {:error, :unauthorized} = Accounts.authentificate_by_email_and_pass(@email, "badpassword")
    end

    test "return not found with no matching user for email" do
      assert {:error, :not_found} = Accounts.authentificate_by_email_and_pass("bad@email.com", @pass)
    end
  end

end
