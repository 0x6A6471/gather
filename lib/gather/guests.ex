defmodule Gather.Guests do
  @moduledoc """
  The Guests context.
  """

  import Ecto.Query, warn: false
  alias Gather.Repo

  alias Gather.Guests.Guest

  @doc """
  Returns the list of guests associated to a user.

  ## Examples

      iex> list_guests(1)
      [%Guest{}, ...]

  """
  def list_guests(user_id) do
    Repo.all(from g in Guest, where: g.user_id == ^user_id, order_by: [asc: g.name])
  end

  @doc """
  Gets a single guest.

  Raises `Ecto.NoResultsError` if the Guest does not exist.

  ## Examples

      iex> get_guest!(123)
      %Guest{}

      iex> get_guest!(456)
      ** (Ecto.NoResultsError)

  """
  def get_guest!(id), do: Repo.get!(Guest, id)

  @doc """
  Creates a guest.

  ## Examples

      iex> create_guest(user, %{field: value})
      {:ok, %Guest{}}

      iex> create_guest(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_guest(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:guests)
    |> Guest.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a guest.

  ## Examples

      iex> update_guest(guest, %{field: new_value})
      {:ok, %Guest{}}

      iex> update_guest(guest, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_guest(%Guest{} = guest, attrs) do
    guest
    |> Guest.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a guest.

  ## Examples

      iex> delete_guest(1)
      {:ok, %Guest{}}

      iex> delete_guest(1)
      {:error, %Ecto.Changeset{}}

  """
  def delete_guest(guest_id) do
    guest = Repo.get!(Guest, guest_id)

    Repo.delete(guest)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking guest changes.

  ## Examples

      iex> change_guest(guest)
      %Ecto.Changeset{data: %Guest{}}

  """
  def change_guest(%Guest{} = guest, attrs \\ %{}) do
    Guest.changeset(guest, attrs)
  end

  @doc """
  Returns a lsit of guests that match the search term.

  ## Examples

      iex> search_by_name(query, user_id)
      [%Guest{}, ...]
  """
  def search_by_name(query, user_id) do
    query =
      from g in Guest,
        where: like(fragment("lower(?)", g.name), ^"%#{String.downcase(query)}%"),
        where: g.user_id == ^user_id

    Repo.all(query)
  end

  @doc """
  Returns a list of states.

  ## Examples

      iex> states()
      ["AL", "AK", ...]
  """
  def list_states do
    [
      "AK",
      "AL",
      "AR",
      "AZ",
      "CA",
      "CO",
      "CT",
      "DE",
      "FL",
      "GA",
      "HI",
      "IA",
      "ID",
      "IL",
      "IN",
      "KS",
      "KY",
      "LA",
      "MA",
      "MD",
      "ME",
      "MI",
      "MN",
      "MO",
      "MS",
      "MT",
      "NC",
      "ND",
      "NE",
      "NH",
      "NJ",
      "NM",
      "NV",
      "NY",
      "OH",
      "OK",
      "OR",
      "PA",
      "RI",
      "SC",
      "SD",
      "TN",
      "TX",
      "UT",
      "VA",
      "VT",
      "WA",
      "WI",
      "WV",
      "WY"
    ]
  end
end
