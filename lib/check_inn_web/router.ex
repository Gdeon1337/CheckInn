defmodule CheckInnWeb.Router do
  use CheckInnWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug CheckInnWeb.Plugs.SetCurrentClient
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authorized do
    plug :fetch_session
    plug Guardian.Plug.Pipeline, module: CheckInnWeb.Plugs.Guardian,
      error_handler: CheckInnWeb.FallbackController
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/", CheckInnWeb do
    pipe_through :browser
    post "/sign-in", SessionController, :create
    post "/sign-out", SessionController, :delete
    resources "/", InnController
    resources "/clients", ClientController
  end

  # Other scopes may use custom stacks.
  # scope "/api", CheckInnWeb do
  #   pipe_through :api
  # end
end
