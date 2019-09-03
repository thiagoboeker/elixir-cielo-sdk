# CieloSdk

**TODO: Add description**

## Installation

This package is not in Hex yet so the way to install is:

```elixir
def deps do
  [
    {:cielo_sdk, git: "https://github.com/thiagoboeker/elixir-cielo-sdk.git"}
  ]
end
```

## Usage

First you have to create a Stub with your credentials to Cielo API and the right endpoints, using the sandbox as example:

```elixir
  stub =
      CieloSdk.create(
        client_id: "xxxxxx-xxxxxx-xxxxx-xxxxxx-xxxxxxx",
        client_secret: "xxxxxxxxxxxxxxxxxxxxxxxx",
        query_url: "https://apiquerysandbox.cieloecommerce.cielo.com.br",
        request_url: "https://apisandbox.cieloecommerce.cielo.com.br"
  )
```

The you can use it to make API calls:

```elixir
      # tokenized payment
      params = %{  
        "MerchantOrderId" => "2014111706",
        "Customer" => %{  
           "Name" => "Comprador Teste"
        },
        "Payment" => %{  
          "Type" => "CreditCard",
          "Amount" => 100,
          "Installments" => 1,
          "SoftDescriptor" => "123456789ABCD",
          "CreditCard" => %{  
              "CardToken" => "6e1bf77a-b28b-4660-b14f-455e2a1c95e9",
              "SecurityCode" => "262",
              "Brand" => "Visa"
          }
        }
    }
```

```elixir
  {:ok, %{body: b, headers: h, request: r, status_code: code}} = Transaction.request(%Transaction{}, stub, params)
```

The JSON payload that is passed to _*request*_ is filtered in a changeset as all API calls before been executed. To check if the payload is valid one can use.

```elixir
  # {error, err} in case of any error in the changeset
  {:ok, changeset} = Transaction.validate(%Transaction, params)
```

## TODO

- [ ] More Documentation
- [ ] Add proper Behaviour  

