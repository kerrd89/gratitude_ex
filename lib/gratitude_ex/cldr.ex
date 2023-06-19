defmodule GratitudeEx.Cldr do
  @moduledoc """
  TODO: consider removing from this attempt at boilerplate
  Define a backend module that will host our
  Cldr configuration and public API.

  Most function calls in Cldr will be calls
  to functions on this module.
  """
  use Cldr,
    locales: ["en"],
    default_locale: "en",
    force_locale_download: Mix.env() in [:prod],
    providers: [Cldr.Number, Cldr.Calendar, Cldr.DateTime, Cldr.Unit],
    gettext: GratitudeExWeb.Gettext
end
