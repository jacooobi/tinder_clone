# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :tinder_clone,
  ecto_repos: [TinderClone.Repo]

# Configures the endpoint
config :tinder_clone, TinderClone.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "fVMKDTT/Xy4A+Myt9Lf/xCa2M4+algaVup6/CDcmYMNMPonzC0kFTaOyKSgVH9Mp",
  render_errors: [view: TinderClone.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TinderClone.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# %% Coherence Configuration %%   Don't remove this line
config :coherence,
  user_schema: TinderClone.User,
  repo: TinderClone.Repo,
  module: TinderClone,
  logged_out_url: "/",
  email_from_name: "TinderClone",
  email_from_email: "tinder_clone@example.com",
  opts: [:authenticatable, :recoverable, :lockable, :trackable, :unlockable_with_token, :invitable, :registerable]

config :coherence, TinderClone.Coherence.Mailer,
  adapter: Swoosh.Adapters.Sendgrid,
  api_key: "your api key here"
# %% End Coherence Configuration %%
