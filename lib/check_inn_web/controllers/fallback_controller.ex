defmodule CheckInnWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use CheckInnWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(CheckInnWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(CheckInnWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, :forbidden}) do
    conn
    |> put_status(403)
    |> json(%{status: 403, message: "forbidden"})
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(401)
    |> json(%{status: 401, message: "unauthorized"})
  end

  def call(conn, {:error, :incorrect_data}) do
    conn
    |> put_status(415)
    |> json(%{status: 415, message: "incorrect_data"})
  end

end
