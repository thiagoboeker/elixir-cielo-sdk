defmodule CieloSdk.Api.Transaction.CreditCard.CardOnFile do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field(:Usage, :string)
    field(:Reason, :string)
  end

  def changeset(changeset, params \\ %{}) do
    changeset
    |> cast(params, [:Usage, :Reason])
    |> validate_inclusion(:Usage, ["First", "Used"])
    |> validate_inclusion(:Reason, ["Recurring", "Unscheduled", "Installments"])
  end
end

defmodule CieloSdk.Api.CreditCard.Tokenizer do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias CieloSdk
  alias CieloSdk.Api.ErrorHandling, as: Err

  embedded_schema do
    field(:CustomerName, :string)
    field(:CardNumber, :string)
    field(:Holder, :string)
    field(:ExpirationDate, :string)
    field(:Brand, :string)
  end

  def is_tokenized(params) when is_map(params) do
    Enum.any?(Map.keys(params), fn k -> k == "CardToken" end)
  end

  def changeset(schema, params \\ %{}) do
    schema
    |> cast(params, [:CustomerName, :CardNumber, :Holder, :ExpirationDate, :Brand])
    |> validate_required([:CustomerName, :CardNumber, :Holder, :ExpirationDate, :Brand])
  end

  def validate(schema, params \\ %{}) do
    __MODULE__.changeset(schema, params)
    |> Err.check_errors(params)
  end

  def create({:ok, _payload} = data, stub) do
    CieloSdk.request(data, :post, "/1/card", stub)
  end
end

defmodule CieloSdk.Api.Transaction.CreditCard do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  import CieloSdk.Api.CreditCard.Tokenizer, only: [is_tokenized: 1]
  alias CieloSdk.Api.Transaction.CreditCard.CardOnFile
  alias CieloSdk.Api.ErrorHandling, as: Err
  alias CieloSdk

  embedded_schema do
    field(:CardNumber, :string)
    field(:Holder, :string)
    field(:ExpirationDate, :string)
    field(:SecurityCode, :string)
    field(:SaveCard, :boolean)
    field(:Brand, :string)
    field(:CardToken, :string)
    embeds_one(:CardOnFile, CardOnFile)
  end

  defp with_token(schema, params) do
    schema
    |> cast(params, [:CardToken, :Brand, :SecurityCode])
    |> validate_required([:CardToken, :Brand])
  end

  defp with_number(schema, params) do
    schema
    |> cast(params, [:CardNumber, :Holder, :ExpirationDate, :SecurityCode, :SaveCard, :Brand])
    |> validate_required([:CardNumber, :ExpirationDate, :Brand])
    |> cast_embed(:CardOnFile)
  end

  def changeset(schema, params \\ %{}) do
    case is_tokenized(params) do
      true -> with_token(schema, params)
      false -> with_number(schema, params)
    end
  end

  def validate(schema, params \\ %{}) do
    __MODULE__.changeset(schema, params)
    |> Err.check_errors(params)
  end

  def zero_auth(schema, stub, params \\ %{}) do
    __MODULE__.validate(schema, params)
    |> CieloSdk.request(:post, "/1/zeroauth", stub)
  end
end
