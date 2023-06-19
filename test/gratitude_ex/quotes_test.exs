defmodule GratitudeEx.QuotesTest do
  use GratitudeEx.DataCase

  alias GratitudeEx.Quotes
  alias GratitudeEx.Factory

  describe "quotes" do
    alias GratitudeEx.Quotes.Quote

    @invalid_attrs %{author: nil, text: nil}

    test "list_quotes/0 returns all quotes" do
      quote = Factory.insert(:quote)
      assert Quotes.list_quotes() == [quote]
    end

    test "get_quote!/1 returns the quote with given id" do
      quote = Factory.insert(:quote)
      assert Quotes.get_quote!(quote.id) == quote
    end

    test "create_quote/1 with valid data creates a quote" do
      valid_attrs = %{author: "some author", text: "some text"}

      assert {:ok, %Quote{} = quote} = Quotes.create_quote(valid_attrs)
      assert quote.author == "some author"
      assert quote.text == "some text"
    end

    test "create_quote/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Quotes.create_quote(@invalid_attrs)
    end

    test "update_quote/2 with valid data updates the quote" do
      quote = Factory.insert(:quote)
      update_attrs = %{author: "some updated author", text: "some updated text"}

      assert {:ok, %Quote{} = quote} = Quotes.update_quote(quote, update_attrs)
      assert quote.author == "some updated author"
      assert quote.text == "some updated text"
    end

    test "update_quote/2 with invalid data returns error changeset" do
      quote = Factory.insert(:quote)
      assert {:error, %Ecto.Changeset{}} = Quotes.update_quote(quote, @invalid_attrs)
      assert quote == Quotes.get_quote!(quote.id)
    end

    test "delete_quote/1 deletes the quote" do
      quote = Factory.insert(:quote)
      assert {:ok, %Quote{}} = Quotes.delete_quote(quote)
      assert_raise Ecto.NoResultsError, fn -> Quotes.get_quote!(quote.id) end
    end

    test "change_quote/1 returns a quote changeset" do
      quote = Factory.insert(:quote)
      assert %Ecto.Changeset{} = Quotes.change_quote(quote)
    end
  end
end
