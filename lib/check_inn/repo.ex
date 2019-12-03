defmodule CheckInn.Repo do
  use Ecto.Repo,
    otp_app: :check_inn,
    adapter: Ecto.Adapters.Postgres
end
