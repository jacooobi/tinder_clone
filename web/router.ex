defmodule TinderClone.Router do
  use TinderClone.Web, :router
  use Coherence.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session
  end

  pipeline :protected do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session, protected: true
    plug :put_user_token
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :browser
    coherence_routes()
  end

  scope "/" do
    pipe_through :protected
    coherence_routes :protected
  end

  scope "/", TinderClone do
    pipe_through :protected # Use the default browser stack

    get "/", PageController, :index
    post "/contact/:id", ContactController, :create
    delete "/contact/:id", ContactController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", TinderClone do
  #   pipe_through :api
  # end

  defp put_user_token(conn, _) do
    current_user = Coherence.current_user(conn).id
    user_id_token = Phoenix.Token.sign(conn, "user_id",
                    Coherence.current_user(conn).id)
    conn
    |> assign(:user_id, user_id_token)
  end
end
