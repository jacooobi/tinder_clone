defmodule TinderClone.Match do
  use TinderClone.Web, :model

  alias TinderClone.{Match, Repo}

  schema "matches" do
    field :room_name, :string
    belongs_to :user_a, TinderClone.User
    belongs_to :user_b, TinderClone.User

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:room_name, :user_a_id, :user_b_id])
    |> validate_required([:room_name])
  end

  def get_match_for(user_1, user_2) do
    query_a = from m in Match, where: m.user_a_id == ^user_1, where: m.user_b_id == ^user_2
    query_b = from m in Match, where: m.user_a_id == ^user_2, where: m.user_b_id == ^user_1

    Repo.all(query_a) ++ Repo.all(query_b)
    |> List.first
  end

  def generate_room_name do
    name = :crypto.strong_rand_bytes(32) |> Base.encode16 |> String.downcase

    case Repo.get_by(Match, room_name: name) do
      nil -> name
      _ -> generate_room_name()
    end
  end
end
