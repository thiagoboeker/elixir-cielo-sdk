defmodule CieloSdk.Api.Recurrency do
  @moduledoc false
  
  alias CieloSdk

  def url(rec_id, resource) do
    "/1/RecurrentPayment/" <> rec_id <> "/" <> resource
  end

  def check_interval(interval) do
    Enum.any?([1, 2, 3, 6, 12], fn valid -> valid == interval end)
  end

  def update({:ok, payload} = data, rec_id, resource, stub) do
    case resource do
      :customer ->
        CieloSdk.request(data, :put, url(rec_id, "Customer"), stub)

      :end_date ->
        CieloSdk.request(data, :put, url(rec_id, "EndDate"), stub)

      :interval ->
        cond do
          check_interval(payload) -> CieloSdk.request(data, :put, url(rec_id, "Interval"), stub)
          true -> {:error, %{error: "INVALID INTERVAL"}}
        end

      :recurrency_day ->
        CieloSdk.request(data, :put, url(rec_id, "RecurrencyDay"), stub)

      :amount ->
        CieloSdk.request(data, :put, url(rec_id, "Amount"), stub)

      :next_pay_date ->
        CieloSdk.request(data, :put, url(rec_id, "NextPaymentDate"), stub)

      :deactivate ->
        CieloSdk.request(data, :put, url(rec_id, "Deactivate"), stub)

      :reactivate ->
        CieloSdk.request(data, :put, url(rec_id, "Reactivate"), stub)
    end
  end

  @doc false
  def update({:error, _} = errors, _, _), do: errors
end
