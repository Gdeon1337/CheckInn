defmodule CheckInn.Clients do
  @moduledoc """
  The Clients context.
  """

  import Ecto.Query, warn: false
  alias CheckInn.Repo

  alias CheckInn.Clients.Client

  @doc """
  Returns the list of clients.

  ## Examples

      iex> list_clients()
      [%Client{}, ...]

  """
  def list_clients do
    Repo.all(Client)
  end

  @doc """
  Gets a single client.

  Raises `Ecto.NoResultsError` if the Client does not exist.

  ## Examples

      iex> get_client!(123)
      %Client{}

      iex> get_client!(456)
      ** (Ecto.NoResultsError)

  """
  def get_client_or_create(ip) do
    client = Client
    |> where([c], c.ip == ^ip)
    |> Repo.one
    case is_nil(client) do
      true -> create_client(%{"ip" => ip})
      false -> {:ok, client}
    end
  end


  def get_client!(id), do: Repo.get!(Client, id)

  @doc """
  Creates a client.

  ## Examples

      iex> create_client(%{field: value})
      {:ok, %Client{}}

      iex> create_client(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_client(attrs \\ %{}) do
    %Client{}
    |> Client.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a client.

  ## Examples

      iex> update_client(client, %{field: new_value})
      {:ok, %Client{}}

      iex> update_client(client, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_client(%Client{} = client, attrs) do
    client
    |> Client.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Client.

  ## Examples

      iex> delete_client(client)
      {:ok, %Client{}}

      iex> delete_client(client)
      {:error, %Ecto.Changeset{}}

  """
  def delete_client(%Client{} = client) do
    Repo.delete(client)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking client changes.

  ## Examples

      iex> change_client(client)
      %Ecto.Changeset{source: %Client{}}

  """
  def change_client(%Client{} = client) do
    Client.changeset(client, %{})
  end

  alias CheckInn.Clients.Inn

  @doc """
  Returns the list of inns.

  ## Examples

      iex> list_inns()
      [%Inn{}, ...]

  """
  def list_inns(client_id) do
    Inn
    |> where([i], i.client_id == ^client_id)
    |> order_by([i], desc: i.date_time)
    |> Repo.all
  end
  def list_inns do
    Repo.all(Inn)
  end

  @doc """
  Gets a single inn.

  Raises `Ecto.NoResultsError` if the Inn does not exist.

  ## Examples

      iex> get_inn!(123)
      %Inn{}

      iex> get_inn!(456)
      ** (Ecto.NoResultsError)

  """
  def get_inn!(id), do: Repo.get!(Inn, id)

  @doc """
  Creates a inn.

  ## Examples

      iex> create_inn(%{field: value})
      {:ok, %Inn{}}

      iex> create_inn(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_inn(attrs \\ %{}) do
    attrs = Map.put(attrs, "correctness", check_inn(attrs))
    %Inn{}
    |> Inn.changeset(attrs)
    |> Repo.insert()
  end

  def check_inn(%{"number" => number}) do
    if is_numeric(number) do
      numbers = String.codepoints(number)
      check_sum(Enum.map(numbers, fn x -> String.to_integer(x) end), length(numbers))
    else
      false
    end
  end

  def check_inn(_attrs) do
    {:error, :incorrect_data}
  end

  def check_sum(numbers, numbers_length) when numbers_length == 10 do
    factors = [2, 4, 10, 3, 5, 9, 4, 6, 8]
    control_number = List.last(numbers)
    checksum_counter(numbers, factors, 9)
    |> check_control_sum(control_number)
  end

  def check_sum(numbers, numbers_length) when numbers_length == 12 do
    factors = [7, 2, 4, 10, 3, 5, 9, 4, 6, 8]
    control_number_first = Enum.at(numbers, -2)
    control_sum = checksum_counter(numbers, factors, 10)
    valid = check_control_sum(control_sum, control_number_first)
    if valid do
      factors =  [3, 7, 2, 4, 10, 3, 5, 9, 4, 6, 8]
      control_number_last = List.last(numbers)
      control_sum = checksum_counter(numbers, factors, 11)
      valid = check_control_sum(control_sum, control_number_last)
    end
    valid
  end


  def check_sum(_numbers, _numbers_length) do
    false
  end

  def checksum_counter(numbers, factors, count) do
    Enum.reduce(Enum.zip(Enum.take(numbers, count), factors), 0, fn {x, f}, s -> (x * f) + s end)
  end

  def check_control_sum(control_sum, control_number) do
    case rem(control_sum, 11) do
      control_number -> true
      10 -> valid = (0 == control_number)
      _ -> false
    end
  end

  def is_numeric(str) do
    case Float.parse(str) do
    {_num, ""} -> true
    _          -> false
    end
  end


  @doc """
  Updates a inn.

  ## Examples

      iex> update_inn(inn, %{field: new_value})
      {:ok, %Inn{}}

      iex> update_inn(inn, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_inn(%Inn{} = inn, attrs) do
    inn
    |> Inn.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Inn.

  ## Examples

      iex> delete_inn(inn)
      {:ok, %Inn{}}

      iex> delete_inn(inn)
      {:error, %Ecto.Changeset{}}

  """
  def delete_inn(%Inn{} = inn) do
    Repo.delete(inn)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking inn changes.

  ## Examples

      iex> change_inn(inn)
      %Ecto.Changeset{source: %Inn{}}

  """
  def change_inn(%Inn{} = inn) do
    Inn.changeset(inn, %{})
  end
end
