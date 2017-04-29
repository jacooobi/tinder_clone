defmodule TinderClone.Factory do
  use ExMachina.Ecto, repo: TinderClone.Repo

  alias TinderClone.{User, Contact, Match}

  def user_factory do
    %User {
      name: sequence(:name, &"user_#{&1}"),
      email: sequence(:email, &"user_#{&1}@email.com"),
      password: "password",
      password_confirmation: "password"
    }
  end

  def contact_factory do
    %Contact {
      user: build(:user),
      contact: build(:user)
    }
  end

  def match_factory do
    %Match {
      room_name: Match.generate_room_name(),
      user_a: build(:user),
      user_b: build(:user)
    }
  end
end
