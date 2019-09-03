defmodule CieloSdk.Api.Transaction.Payment do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias CieloSdk.Api.Transaction.CreditCard
  alias CieloSdk.Api.Transaction.Payment.RecurrentPayment

  embedded_schema do
    field(:Type, :string)
    field(:Amount, :integer)
    field(:Currency, :string)
    field(:Country, :string)
    field(:ServiceTaxAmount, :integer)
    field(:Installments, :integer)
    field(:Interest, :string)
    field(:Capture, :boolean)
    field(:Recurrent, :boolean)
    field(:Authenticate, :boolean)
    field(:SoftDescriptor, :string)
    embeds_one(:RecurrentPayment, RecurrentPayment)
    field(:IsCryptoCurrencyNegotiation, :boolean)
    embeds_one(:CreditCard, CreditCard)
  end

  def changeset(changeset, params \\ %{}) do
    changeset
    |> cast(params, [
      :Type,
      :Amount,
      :Currency,
      :Country,
      :ServiceTaxAmount,
      :SoftDescriptor,
      :Installments,
      :Interest,
      :Capture,
      :Authenticate,
      :IsCryptoCurrencyNegotiation,
      :Recurrent
    ])
    |> validate_required([:Type, :Amount, :Installments])
    |> cast_embed(:RecurrentPayment)
    |> cast_embed(:CreditCard)
  end
end

defmodule CieloSdk.Api.Transaction.Payment.RecurrentPayment do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field(:AuthorizeNow, :boolean)
    field(:EndDate, :date)
    field(:Interval, :string)
    field(:StartDate, :date)
  end

  def changeset(schema, params \\ %{}) do
    schema
    |> cast(params, [:AuthorizeNow, :EndDate, :Interval, :StartDate])
    |> validate_required([:AuthorizeNow])
    |> validate_inclusion(:Interval, ["Monthly", "Bimonthly", "Quartely", "SemiAnnual", "Annual"])
  end
end
