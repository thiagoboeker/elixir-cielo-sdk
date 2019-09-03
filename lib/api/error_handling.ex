defmodule CieloSdk.Api.ErrorHandling do
  @moduledoc false
  
  import Ecto.Changeset

  def check_errors(changeset, params) do
    cond do
      changeset.valid? -> {:ok, params}
      true -> errors(changeset)
    end
  end

  defp errors(changeset) do
    err =
      traverse_errors(changeset, fn {msg, opts} ->
        Enum.reduce(opts, msg, fn {key, value}, acc ->
          String.replace(acc, "%{#{key}}", to_string(value))
        end)
      end)

    {:error, err}
  end
end
