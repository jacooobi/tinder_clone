defmodule TinderClone.MatchTest do
  use TinderClone.ModelCase

  import TinderClone.Factory

  alias TinderClone.Match

  @valid_attrs %{room_name: "superlongstringwithrandomcharacters"}

  @invalid_attrs %{room_name: ""}


  describe "valid match" do
    test "changeset with valid attributes" do
      changeset = Match.changeset(%Match{}, @valid_attrs)
      assert changeset.valid?
    end
  end

  describe "invalid match" do
    test "changeset with invalid attributes" do
      changeset = Match.changeset(%Match{}, @invalid_attrs)
      refute changeset.valid?
    end
  end

  describe "finding a match" do
    setup do
      [user_a, user_b] = insert_pair(:user)
      match = insert(:match, user_a: user_a, user_b: user_b)

      {:ok, user_a: user_a, user_b: user_b, match: match}
    end

    test "returns a correct match for both users", %{user_a: user_a, user_b: user_b, match: match} do

      assert match.id == Match.get_match_for(user_a.id, user_b.id).id
      assert match.id == Match.get_match_for(user_b.id, user_a.id).id
    end
  end
end
