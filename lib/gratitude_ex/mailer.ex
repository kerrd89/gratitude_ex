defmodule GratitudeEx.Mailer do
  use Swoosh.Mailer, otp_app: :gratitude_ex

  alias Soosh.Email

  @no_reply_address "no-reply@gratitude.com"

  @doc """
  Sets the recipient in the `from` field to be the no-reply email address.

  Simply add to the pipeline when constructing a new `Swoosh.Email`:

      new()
      |> to({name, email})
      |> from_no_reply()
      |> subject("Gratitude Email Subject")

  """
  @spec from_no_reply(Email.t()) :: Email.t()
  def from_no_reply(email), do: Email.from(email, {@no_reply_address, @no_reply_address})
end
