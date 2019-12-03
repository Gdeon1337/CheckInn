defmodule CheckInnWeb.LayoutView do
  use CheckInnWeb, :view
  alias CheckInnWeb.Plugs.Guardian.Plug, as: GPlug

  def current_user(conn) do
    GPlug.current_resource(conn)
  end
end
