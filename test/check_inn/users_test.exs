defmodule CheckInn.UsersTest do
  use CheckInn.DataCase

  alias CheckInn.Users

  describe "users" do
    alias CheckInn.Users.User

    @valid_attrs %{login: "some login", password: "some password"}
    @update_attrs %{login: "some updated login", password: "some updated password"}
    @invalid_attrs %{login: nil, password: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Users.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Users.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Users.create_user(@valid_attrs)
      assert user.login == "some login"
      assert user.password == "some password"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Users.update_user(user, @update_attrs)
      assert user.login == "some updated login"
      assert user.password == "some updated password"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)
      assert user == Users.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Users.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Users.change_user(user)
    end
  end

  describe "roles" do
    alias CheckInn.Users.Role

    @valid_attrs %{title: "some title"}
    @update_attrs %{title: "some updated title"}
    @invalid_attrs %{title: nil}

    def role_fixture(attrs \\ %{}) do
      {:ok, role} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Users.create_role()

      role
    end

    test "list_roles/0 returns all roles" do
      role = role_fixture()
      assert Users.list_roles() == [role]
    end

    test "get_role!/1 returns the role with given id" do
      role = role_fixture()
      assert Users.get_role!(role.id) == role
    end

    test "create_role/1 with valid data creates a role" do
      assert {:ok, %Role{} = role} = Users.create_role(@valid_attrs)
      assert role.title == "some title"
    end

    test "create_role/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_role(@invalid_attrs)
    end

    test "update_role/2 with valid data updates the role" do
      role = role_fixture()
      assert {:ok, %Role{} = role} = Users.update_role(role, @update_attrs)
      assert role.title == "some updated title"
    end

    test "update_role/2 with invalid data returns error changeset" do
      role = role_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_role(role, @invalid_attrs)
      assert role == Users.get_role!(role.id)
    end

    test "delete_role/1 deletes the role" do
      role = role_fixture()
      assert {:ok, %Role{}} = Users.delete_role(role)
      assert_raise Ecto.NoResultsError, fn -> Users.get_role!(role.id) end
    end

    test "change_role/1 returns a role changeset" do
      role = role_fixture()
      assert %Ecto.Changeset{} = Users.change_role(role)
    end
  end
end
