defmodule PooltoolServerWeb.Router do
  use PooltoolServerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PooltoolServerWeb do
    pipe_through :api

    scope "/ping" do
      get "/", PingController, :ping
    end

    scope "/auth" do
      post "/sign-up", AuthController, :sign_up
      post "/sign-in", AuthController, :sign_in
      get "/confirm-email", AuthController, :confirm_email
      post "/forgot-password", AuthController, :forgot_password
      put "/reset-password", AuthController, :reset_password
    end
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: PooltoolServerWeb.Telemetry
    end
  end
end
