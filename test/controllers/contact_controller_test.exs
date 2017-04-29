defmodule TinderClone.ContactControllerTest do
  use TinderClone.ConnCase

  import TinderClone.Factory

  alias TinderClone.Contact

  describe "with authorized user" do
    setup %{conn: conn} do
      current_user = insert(:user)

      {:ok, conn: assign(conn, :current_user, current_user), current_user: current_user}
    end

    test "POST /contact/:id creates a new contact", %{conn: conn} do
      second_user = insert(:user)

      conn = post conn, "/contact/#{second_user.id}"

      assert Repo.one(from c in Contact, select: count("*")) == 1
      assert redirected_to(conn, 302) =~ "/"
    end


    test "DELETE /contact/:id removes a contact", %{conn: conn, current_user: current_user} do
      contact = insert(:contact, user: current_user)

      conn = delete conn, "/contact/#{contact.contact.id}"

      assert Repo.one(from c in Contact, select: count("*")) == 0
      assert redirected_to(conn, 302) =~ "/"

    end
  end
end
