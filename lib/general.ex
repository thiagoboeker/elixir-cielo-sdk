defmodule CieloSdk.Stub do
  @moduledoc false

  defstruct client_id: nil, client_secret: nil, query_url: nil, request_url: nil
end

defmodule CieloSdk do
  @moduledoc false

  alias CieloSdk.Stub

  def create(
        client_id: client_id,
        client_secret: client_secret,
        query_url: query_url,
        request_url: request_url
      ) do
    %Stub{
      client_id: client_id,
      client_secret: client_secret,
      query_url: query_url,
      request_url: request_url
    }
  end

  def requestp(method, url, params, stub) do
    HTTPoison.request(
      method,
      url,
      params,
      [
        {"Content-Type", "application/json"},
        {"MerchantId", stub.client_id},
        {"MerchantKey", stub.client_secret}
      ]
    )
  end

  defp base_url(stub, route), do: stub.request_url <> route

  def request({:error, _e} = err), do: err

  def request({:ok, changeset}, method, url, stub) do
    case CieloSdk.requestp(method, base_url(stub, url), Poison.encode!(changeset), stub) do
      {:ok, payload} -> {:ok, payload}
      {:error, err} -> {:error, err}
    end
  end
end
