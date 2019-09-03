defmodule CieloSdk.Api.Address do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field(:Street, :string)
    field(:Number, :string)
    field(:Complement, :string)
    field(:ZipCode, :string)
    field(:City, :string)
    field(:State, :string)
    field(:Country, :string)
  end

  def changeset(changeset, params \\ %{}) do
    changeset
    |> cast(params, [:Street, :Number, :Complement, :ZipCode, :City, :State, :Country])
  end
end
