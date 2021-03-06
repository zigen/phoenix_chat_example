defmodule AwesomeChatWeb.Router do
  use AwesomeChatWeb, :router

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

  scope "/", AwesomeChatWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController, only: [:new, :create, :edit, :show, :update, :delete]
    get "/login", UserController, :login
    post "/login", UserController, :do_login
    delete "/logout", UserController, :logout
  end

  # Other scopes may use custom stacks.
  # scope "/api", AwesomeChatWeb do
  #   pipe_through :api
  # end
end
