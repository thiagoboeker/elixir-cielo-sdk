defmodule CieloSdk.Api.Boleto do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias CieloSdk.Api.Customer
  alias CieloSdk.Api.ErrorHandling, as: Err

  embedded_schema do
    field(:MerchantOrderId, :string)
    embeds_one(:Customer, Customer)
    embeds_one(:Payment, CieloSdk.Api.Boleto.Payment)
  end

  def changeset(schema, params \\ %{}) do
    schema
    |> cast(params, [:MerchantOrderId])
    |> cast_embed(:Customer)
    |> cast_embed(:Payment)
    |> validate_required([:MerchantOrderId, :Customer, :Payment])
  end

  def validate(schema, params \\ %{}) do
    __MODULE__.changeset(schema, params)
    |> Err.check_errors(params)
  end

  def request(schema, stub, params \\ %{}) do
    __MODULE__.validate(schema, params)
    |> CieloSdk.request(:post, "/1/sales", stub)
  end
end

defmodule CieloSdk.Api.Boleto.Payment do
  @moduledoc false
  
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field(:Type, :string)
    field(:Amount, :integer)
    field(:Provider, :string)
    field(:Address, :string)
    field(:BoletoNumber, :string)
    field(:Assignor, :string)
    field(:Demonstrative, :string)
    field(:ExpirationDate, :string)
    field(:Identification, :string)
    field(:Instructions, :string)
  end

  def changeset(schema, params \\ %{}) do
    schema
    |> cast(params, [
      :Type,
      :Amount,
      :Provider,
      :Address,
      :BoletoNumber,
      :Assignor,
      :Demonstrative,
      :ExpirationDate,
      :Identification,
      :Instructions
    ])
    |> validate_required([:Type, :Provider])
  end
end
