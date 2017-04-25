defmodule TinderClone.RoomChannel do
  use Phoenix.Channel

  import Ecto.Query
  alias TinderClone.{Match, Repo, User}

  def join("room:lobby", params, socket) do
    case Phoenix.Token.verify(socket, "user_id", params["token"], max_age: 1000000) do
      {:ok, user_id} -> {:ok, assign(socket, :user_id, user_id)}
      {:error, _reason} -> {:error, %{reason: "unauthorized"}}
    end
  end

  def join("room:" <> private_room_id, params, socket) do
    q = from m in Match, where: m.room_name == ^private_room_id, limit: 1
    [room] = Repo.all(q)


     case Phoenix.Token.verify(socket, "user_id", params["token"], max_age: 1000000) do
      {:ok, user_id} ->
        if Enum.any?([room.user_a_id, room.user_b_id], fn(id) -> id == user_id end) do
          {:ok, assign(socket, :user_id, user_id)}
        end
      {:error, _reason} ->
        {:error, %{reason: "unauthorized"}}
      end
  end

  def handle_in("new_msg", payload, socket) do
    user = Repo.get(User, socket.assigns.user_id)

    broadcast! socket, "new_msg", %{user: user.name, body: payload["body"]}
    {:noreply, socket}
  end
end
