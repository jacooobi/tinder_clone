defmodule TinderClone.Contact do
  use TinderClone.Web, :model

  alias TinderClone.User

  schema "contacts" do
    belongs_to :user, User
    belongs_to :contact, User
  end

end
