defmodule GratitudeExWeb.Components.Modals do
  @moduledoc """
  Functions to render modals.
  """
  use Phoenix.Component

  @doc """
  Renders a modal used to wrap a form. The form is passed in via the inner block.

  ## Examples

      <.form_modal return_to="/home/path">
        # ...inner block contents
      </.form_modal>

  """

  attr :return_to, :string, default: nil, doc: "Path modal will return to on exit"
  attr :rest, :global, include: ~w(id)

  attr :target, :any,
    default: nil,
    doc: "Optional alternative to the parent LiveView for targeting the 'close_modal' event"

  slot :inner_block, required: true

  def form_modal(assigns) do
    ~H"""
    <div class="phx-modal fade-in" {@rest}>
      <div
        id="modal-container"
        class="absolute left-0"
        aria-labelledby="modal-title"
        role="dialog"
        aria-modal="true"
      >
        <!-- modal background -->
        <div class="fixed inset-0 bg-grey-900 bg-opacity-50 transition-opacity"></div>

        <.focus_wrap id="modal-content" class="fixed inset-0 overflow-y-auto">
          <div class="flex items-center justify-center min-h-full p-4 sm:p-0">
            <div
              phx-click-away="close_modal"
              phx-target={@target}
              phx-value-return-to={@return_to}
              class="bg-white min-w-[95%] sm:min-w-[60%] md:min-w-[40%] max-w-fit flex flex-col text-grey-600 rounded-2xl p-4 sm:p-8 md:p-10"
            >
              <%= render_slot(@inner_block) %>
            </div>
          </div>
        </.focus_wrap>
      </div>
    </div>
    """
  end
end
