defmodule TinderClone.RoomControllerTest do
  use TinderClone.ConnCase

  import TinderClone.Factory

  describe "with authorized user" do
    setup %{conn: conn} do
      current_user = insert(:user)

      {:ok, conn: assign(conn, :current_user, current_user), current_user: current_user}
    end

    test "GET /private_room/:id displays a private chat", %{conn: conn, current_user: current_user} do

      second_user = insert(:user)
      match = insert(:match, user_a: current_user, user_b: second_user)

      conn = get conn, "/private_room/#{match.room_name}"

      assert html_response(conn, 200) =~ "Private chat between #{current_user.name} and #{second_user.name}"
    end
  end
end
