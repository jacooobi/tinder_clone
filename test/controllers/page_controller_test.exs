defmodule TinderClone.PageControllerTest do
  use TinderClone.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Please log in before entering the chat"
  end
end
