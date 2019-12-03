defmodule CheckInnWeb.ClientChannel do
  use CheckInnWeb, :channel
  alias CheckInn.Clients
  require Logger

  def join("client:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  def handle_in("CHECK_INN", payload, socket) do
    Logger.info(inspect(payload))
    Logger.info(inspect(socket))
    payload = Map.put(payload, "client_id", socket.assigns[:current_client_id])
    case Clients.create_inn(payload) do
      {:ok, inn} ->
        broadcast!(socket, "client:#{inn.client_id}:new_message", %{number: inn.number, date_time: inn.date_time, correctness: inn.correctness})
        {:reply, :ok, socket}
      {:error, _} ->
        {:noreply, socket}
    end
  end

  # def handle_in("CHECK_INN", payload, socket) do
  #   room_id = socket.assigns[:room_id]
  #   user = Repo.get(User, socket.assigns[:current_user_id])
  #   message = %{content: content, user: %{username: user.username}}

  #   broadcast!(socket, "room:#{room_id}:new_message", message)

  #   {:reply, :ok, socket}
  # end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (client:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
