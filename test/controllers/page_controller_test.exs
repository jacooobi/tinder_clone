defmodule TinderClone.PageControllerTest do
  use TinderClone.ConnCase

  import TinderClone.Factory

  describe "with unauthorized user" do
    test "GET / redirects to log in page", %{conn: conn} do
      conn = get conn, "/"

      assert html_response(conn, 200) =~ "Please log in before entering the chat"
    end
  end

  describe "with authorized user" do
    setup %{conn: conn} do
      user = insert(:user)

      {:ok, conn: assign(conn, :current_user, user), user: user}
    end

    test "GET / displays the main page", %{conn: conn, user: user} do
      conn = get conn, "/"

      assert html_response(conn, 200) =~ "Hello #{user.name}"
    end
  end
end
