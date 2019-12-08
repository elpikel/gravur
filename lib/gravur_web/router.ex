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
    delete "/sign_out", SessionController, :delete

    resources "/books", BookController
    resources "/greetings", GreetingController
  end

  # Other scopes may use custom stacks.
  # scope "/api", GravurWeb do
  #   pipe_through :api
  # end
end
