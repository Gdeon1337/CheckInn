defmodule CheckInnWeb.InnController do
  use CheckInnWeb, :controller

  alias CheckInn.Clients
  alias CheckInn.Clients.Inn
  require Logger


  def index(conn, _params) do
    with {:ok, client} <- Clients.get_client_or_create(conn.remote_ip |> :inet.ntoa() |> to_string()) do
      inns = Clients.list_inns(client.id)
      changeset = Clients.change_inn(%Inn{})
      render(conn, "index.html", %{inns: inns, changeset: changeset})
    end
  end

  def new(conn, _params) do
    changeset = Clients.change_inn(%Inn{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"inn" => inn_params}) do
    with {:ok, client} <- Clients.get_client_or_create(conn.remote_ip |> :inet.ntoa() |> to_string()) do
      inn_params = Map.put(inn_params, "client_id", client.id)
      case Clients.create_inn(inn_params) do
        {:ok, _inn} ->
          conn
          |> put_flash(:info, "Inn created successfully.")
          |> redirect(to: Routes.inn_path(conn, :index))

        {:error, _changeset} ->
          conn
          |> redirect(to: Routes.inn_path(conn, :index))
      end
    end
  end

  def show(conn, %{"id" => id}) do
    inn = Clients.get_inn!(id)
    render(conn, "show.html", inn: inn)
  end

  def edit(conn, %{"id" => id}) do
    inn = Clients.get_inn!(id)
    changeset = Clients.change_inn(inn)
    render(conn, "edit.html", inn: inn, changeset: changeset)
  end

  def update(conn, %{"id" => id, "inn" => inn_params}) do
    inn = Clients.get_inn!(id)

    case Clients.update_inn(inn, inn_params) do
      {:ok, inn} ->
        conn
        |> put_flash(:info, "Inn updated successfully.")
        |> redirect(to: Routes.inn_path(conn, :show, inn))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", inn: inn, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    inn = Clients.get_inn!(id)
    {:ok, _inn} = Clients.delete_inn(inn)

    conn
    |> put_flash(:info, "Inn deleted successfully.")
    |> redirect(to: Routes.inn_path(conn, :index))
  end
end
