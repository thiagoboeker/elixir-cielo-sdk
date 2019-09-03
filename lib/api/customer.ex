defmodule CieloSdk.Api.Customer do
  @moduledoc false
  
  use Ecto.Schema
  import Ecto.Changeset
  alias CieloSdk.Api.Address
  alias CieloSdk.Api.ErrorHandling, as: Err

  embedded_schema do
    field(:Name, :string)
    field(:Email, :string)
    field(:Birthdate, :string)
    field(:Identity, :string)
    field(:IdentityType, :string)
    embeds_one(:Address, Address)
    embeds_one(:DeliveryAddress, Address)
  end

  def changeset(schema, params \\ %{}) do
    schema
    |> cast(params, [:Name, :Email, :Birthdate, :Identity, :IdentityType])
    |> cast_embed(:Address)
    |> cast_embed(:DeliveryAddress)
  end

  def validate(schema, params \\ %{}) do
    __MODULE__.changeset(schema, params)
    |> Err.check_errors(params)
  end
end
