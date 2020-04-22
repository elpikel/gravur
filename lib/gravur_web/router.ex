defmodule GravurWeb.Router do
  use GravurWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GravurWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/sessions", SessionController, only: [:new, :create]
    resources "/registrations", RegistrationController, only: [:new, :create]
    get "/verification/verify/:user_id/:verification_code", VerificationController, :verify
    get "/verification/send/:user_id", VerificationController, :send
    get "/verification/show/:user_id", VerificationController, :show
    post "/invitation", InvitationController, :send
    delete "/sign_out", SessionController, :delete

    resources "/books", BookController do
      resources "/greetings", GreetingController
      resources "/printings", PrintingController, only: [:create]
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", GravurWeb do
  #   pipe_through :api
  # end
end
