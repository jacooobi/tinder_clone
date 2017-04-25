defmodule TinderClone.RoomController do
  use TinderClone.Web, :controller

  alias TinderClone.{Repo, Match, User}

  def show(conn, params) do

    query = from m in Match, where: m.room_name == ^params["id"], limit: 1
    [room] = Repo.all(query)

    users = [Repo.get(User, room.user_a_id), Repo.get(User, room.user_b_id)]


    render conn, "show.html", users: users
  end
end
