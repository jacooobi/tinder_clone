defmodule TinderClone.PageController do
  use TinderClone.Web, :controller

  alias TinderClone.Repo

  def index(conn, _params) do
    users = conn.assigns[:current_user].id |> users_list_without_current
    render conn, "index.html", users: users
  end

  defp users_list_without_current(user_id) do
    query = from u in "users", where: not u.id in [^user_id], select: %{id: u.id, email: u.email, name: u.name}
    query |> Repo.all()
  end
end
