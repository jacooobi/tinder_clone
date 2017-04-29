defmodule TinderClone.RoomChannel do
  use Phoenix.Channel

  alias TinderClone.{Match, Repo, User}

  def join("room:lobby", params, socket) do
    case user_verification(socket, params["token"]) do
      {:ok, user_id} -> {:ok, assign(socket, :user_id, user_id)}
      {:error, _reason} -> {:error, %{reason: "unauthorized"}}
    end
  end

  def join("room:" <> private_room_id, params, socket) do
    room = Repo.get_by(Match, room_name: private_room_id)

     case user_verification(socket, params["token"]) do
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

  defp user_verification(socket, token) do
    Phoenix.Token.verify(socket, "user_id", token, max_age: 1000000)
  end
end
