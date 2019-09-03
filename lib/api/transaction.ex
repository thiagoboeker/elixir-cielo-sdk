defmodule CieloSdk.Api.PaymentCC do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias CieloSdk
  alias CieloSdk.Api.Customer
  alias CieloSdk.Api.PaymentCC.Payment
  alias CieloSdk.Api.ErrorHandling, as: Err

  embedded_schema do
    field(:MerchantOrderId, :string)
    embeds_one(:Customer, Customer)
    embeds_one(:Payment, Payment)
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
