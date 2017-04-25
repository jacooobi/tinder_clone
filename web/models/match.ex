defmodule TinderClone.Match do
  use TinderClone.Web, :model

  alias TinderClone.{Match, Repo}


  schema "matches" do
    field :room_name, :string
    belongs_to :user_a, TinderClone.UserA
    belongs_to :user_b, TinderClone.UserB

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:room_name])
    |> validate_required([:room_name])
  end

  def room_name_for(user_1, user_2) do
    query_a = from m in Match, where: m.user_a_id == ^user_1, where: m.user_b_id == ^user_2
    query_b = from m in Match, where: m.user_a_id == ^user_2, where: m.user_b_id == ^user_1

    [match] = Repo.all(query_a) ++ Repo.all(query_b) |> Enum.uniq

    match.room_name
  end


end
