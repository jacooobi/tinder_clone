defmodule TinderClone.ContactController do
  use TinderClone.Web, :controller
  alias TinderClone.{Repo, Contact, Match, User}

  def create(conn, params) do
    { favorited_user_id, current_user_id } = fetch_ids(conn, params)

    Repo.insert(%Contact{user_id: current_user_id,
                         contact_id: favorited_user_id})

    if User.matched?(favorited_user_id, current_user_id) do
      Repo.insert(Match.changeset(%Match{room_name: Match.generate_room_name(), user_a_id: favorited_user_id, user_b_id: current_user_id}))
    end

    redirect(conn, to: "/")
  end

  def delete(conn, params) do
    { favorited_user_id, current_user_id } = fetch_ids(conn, params)

    if User.matched?(favorited_user_id, current_user_id) do
      Match.get_match_for(favorited_user_id, current_user_id)
      |> Repo.delete
    end

    query = from c in Contact, where: c.user_id == ^current_user_id, where: c.contact_id == ^favorited_user_id, limit: 1

    Repo.all(query) |> List.first |> Repo.delete

    redirect(conn, to: "/")
  end

  defp fetch_ids(conn, params) do
    { String.to_integer(params["id"]), conn.assigns.current_user.id }
  end
end
