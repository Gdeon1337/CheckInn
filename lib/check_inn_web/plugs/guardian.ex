defmodule CheckInnWeb.Plugs.Guardian do
  use Guardian, otp_app: :check_inn
  alias CheckInn.Users
  require Logger

  def subject_for_token(user, claims) do
    Logger.info("subject_for_token")
    sub = to_string(user.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    Logger.info("resource_from_claims")
    user = Users.get_user(claims["sub"])
    if is_nil(user) do
      {:error, :unauthorized}
    else
      {:ok, user}
    end
  end

end