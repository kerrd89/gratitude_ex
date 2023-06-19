defmodule GratitudeEx.Events.UserCreated do
  @moduledoc """
  Dispatches events to event handlers when a user is created.
  """
  use GratitudeEx.Events.Dispatcher

  @impl GratitudeEx.Events.Dispatcher
  def handlers do
    [
      GratitudeEx.Notifications.EventHandlers.UserCreated
    ]
  end
end
