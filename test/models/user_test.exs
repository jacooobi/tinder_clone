defmodule TinderClone.UserTest do
  use TinderClone.ModelCase

  import TinderClone.Factory

  alias TinderClone.{User, Contact}

  @valid_attrs %{
    name: "user",
    email: "user@email.com",
    password: "password",
    password_confirmation: "password"
  }

  @missing_name_attrs %{
    @valid_attrs | name: ""
  }

  @missing_email_attrs %{
    @valid_attrs | email: ""
  }

  @unmatched_passwords_attrs %{
    @valid_attrs | password: "passw0rd"
  }

  describe "valid user" do
    test "creates valid user" do
      user = User.changeset(%User{}, @valid_attrs)

      assert user.valid?
    end
  end

  describe "invalid user" do
    test "with mismatched passwords" do
      user = User.changeset(%User{}, @unmatched_passwords_attrs)

      refute user.valid?
    end

    test "with missing name" do
      user = User.changeset(%User{}, @missing_name_attrs)

      refute user.valid?
    end

    test "with missing email" do
      user = User.changeset(%User{}, @missing_email_attrs)

      refute user.valid?
    end

    test "with non-unique email" do
      user1 = user2 = User.changeset(%User{}, @valid_attrs)
      Repo.insert(user1)

      assert {:error, _} = Repo.insert(user2)
    end
  end

  describe "user contacts" do

    setup do
      [user_1, user_2] = insert_pair(:user)

      {:ok, user1: user_1, user2: user_2}
    end

    test "adding user contacts", %{user1: user1, user2: user2} do
      insert(:contact, user: user1, contact: user2)

      assert User.favorited_by?(user1.id, user2.id)
    end

    test "two mirrored contacts make a match", %{user1: user1, user2: user2} do
      insert(:contact, user: user1, contact: user2)
      insert(:contact, user: user2, contact: user1)

      assert User.matched?(user1.id, user2.id)
      assert User.matched?(user2.id, user1.id)
    end
  end
end
