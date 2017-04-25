defmodule TinderClone.User do
  use TinderClone.Web, :model
  use Coherence.Schema

  alias TinderClone.{Repo, User}

  schema "users" do
    field :name, :string
    field :email, :string
    many_to_many :contacts, TinderClone.User, join_through: TinderClone.Contact, join_keys: [user_id: :id, contact_id: :id]
    coherence_schema

    timestamps
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:name, :email] ++ coherence_fields)
    |> validate_required([:name, :email])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> validate_coherence(params)
  end

  def favorited_by?(user_favoriting_id, user_favorited_id) do
    Repo.get(User, user_favoriting_id)
    |> Repo.preload(:contacts)
    |> Map.fetch!(:contacts)
    |> Enum.any?(fn(c) -> c.id == user_favorited_id end)
  end

  def matched?(user_a, user_b) do
    favorited_by?(user_a, user_b) && favorited_by?(user_b, user_a)
  end
 end

