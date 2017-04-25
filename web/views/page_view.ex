defmodule TinderClone.PageView do
  use TinderClone.Web, :view
  alias TinderClone.{User, Match}

  def contact_link(conn, user_id) do
    cur_user_id = conn.assigns.current_user.id
    if User.favorited_by?(cur_user_id, user_id) do
      link("Remove from favorites", to: "/contact/#{user_id}", method: :delete)
    else
      link("Add to favorites", to: "/contact/#{user_id}", method: :post)
    end
  end

  def chat_link(conn, user_id) do
    cur_user_id = conn.assigns.current_user.id
    if User.matched?(cur_user_id, user_id) do
      match = Match.get_match_for(cur_user_id, user_id)
      link("Chat with me!", to: "/private_room/#{match.room_name}")
    end
  end
end
