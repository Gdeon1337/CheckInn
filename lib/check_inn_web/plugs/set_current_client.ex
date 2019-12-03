defmodule CheckInnWeb.Plugs.SetCurrentClient do
  import Plug.Conn

  alias CheckInn.Clients


  def init(_params) do
  end

  def call(conn, _params) do
    with {:ok, client} <- Clients.get_client_or_create(conn.remote_ip |> :inet.ntoa() |> to_string()) do
      conn
        |> assign(:current_client, client.id)
    end
  end
end