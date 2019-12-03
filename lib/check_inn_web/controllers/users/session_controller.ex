defmodule CheckInnWeb.SessionController do
  use CheckInnWeb, :controller

  alias CheckInnWeb.Plugs.Guardian.Plug, as: GPlug
  alias CheckInn.Users
  require Logger

  action_fallback CheckInnWeb.FallbackController

  def check_user(%{"password" => password, "login" => login}) do
    Logger.info("check_user")
    user = Users.get_user_by_login(login)
    if check_pass(user, password) do
      {:ok, user}
    else
      {:error, :unauthorize}
    end
  end

  def check_user(_attrs) do
    Logger.info("error_no_param")
    {:error, :incorrect_data}
  end

  def check_pass(user, password) when not is_nil(user) do
    Logger.info("check_pass")
    Bcrypt.verify_pass(password, user.password)
  end

  def check_pass(user, _password) when is_nil(user) do
    Logger.info("incorrect login or password")
    false
  end

  def create(conn, params) do
    case check_user(params) do
      {:ok, user} ->
        Logger.info("OK users")
        conn
        |> GPlug.sign_in(user)
        |> redirect(to: Routes.inn_path(conn, :index))
      {:error, :incorrect_data} ->
        conn
        |> put_flash(:error, "Ошибка авторизации")
        |> redirect(to: Routes.inn_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Ошибка авторизации")
        |> redirect(to: Routes.inn_path(conn, :index))
    end
  end

  def delete(conn, _params) do
    Logger.info("delete_session")
    conn
    |> GPlug.sign_out()
    |> json(%{})
  end

  def show(conn, _params) do
    Logger.info("show_me")
    user = GPlug.current_resource(conn)
    json(conn, user)
  end

end