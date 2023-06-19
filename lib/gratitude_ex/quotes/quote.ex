defmodule GratitudeEx.Quotes.Quote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "quotes" do
    field :author, :string
    field :text, :string

    timestamps()
  end

  @doc false
  def changeset(quote, attrs) do
    quote
    |> cast(attrs, [:text, :author])
    |> validate_required([:text, :author])
  end
end
