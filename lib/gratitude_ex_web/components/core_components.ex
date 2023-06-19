defmodule GratitudeExWeb.CoreComponents do
  @moduledoc """
  Provides core UI components.

  At the first glance, this module may seem daunting, but its goal is
  to provide some core building blocks in your application, such modals,
  tables, and forms. The components are mostly markup and well documented
  with doc strings and declarative assigns. You may customize and style
  them in any way you want, based on your application growth and needs.

  The default components use Tailwind CSS, a utility-first CSS framework.
  See the [Tailwind CSS documentation](https://tailwindcss.com) to learn
  how to customize them or feel free to swap in another framework altogether.

  Icons are provided by [heroicons](https://heroicons.com). See `icon/1` for usage.
  """
  use Phoenix.Component

  import GratitudeExWeb.Gettext

  alias GratitudeExWeb.Components.Buttons

  alias Ecto.Changeset
  alias Phoenix.LiveView.JS

  @doc """
  Renders a live component inside a modal.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <.modal return_to={~p"/jars"}>
        <.live_component
          module={GratitudeExWeb.Jarslive.AddEditJarForm}
          id={@jar.id || :new}
          title={@page_title}
          action={@live_action}
          return_to={~p"/jars"}
          jar: @jar
        />
      </.modal>
  """
  def modal(assigns) do
    assigns =
      assigns
      |> assign_new(:return_to, fn -> nil end)
      |> assign_new(:title, fn -> [] end)

    ~H"""
    <div id="modal" class="phx-modal fade-in" phx-remove={hide_modal()}>
      <div
        id="modal-container"
        class="absolute left-0 z-10"
        aria-labelledby="modal-title"
        role="dialog"
        aria-modal="true"
      >
        <!-- modal background -->
        <div class="fixed inset-0 bg-grey-900 bg-opacity-50 transition-opacity"></div>

        <.focus_wrap id="modal-content" class="fixed z-10 inset-0 overflow-y-auto">
          <div class="flex items-center justify-center min-h-full px-4 sm:px-0">
            <div class="bg-white min-w-full sm:min-w-[30rem] max-w-fit min-h-[30vh] flex flex-col text-grey-600 divide-y divide-grey-200 rounded-md">
              <div class="flex items-center justify-between mb-1.5 ml-6 mr-7 mt-5">
                <h3 class="font-semibold leading-normal text-lg text-navy-blue-10">
                  <%= render_slot(@title) %>
                </h3>
                <%= if @return_to do %>
                  <%= live_patch(
                    to: @return_to,
                    id: "close",
                    class: "phx-modal-close",
                    phx_click: hide_modal()
                  ) do %>
                    <%= close_button() %>
                  <% end %>
                <% else %>
                  <a id="close" href="#" class="phx-modal-close" phx-click={hide_modal()}>
                    <%= close_button() %>
                  </a>
                <% end %>
              </div>

              <div class="flex flex-col grow space-y-4 overflow-scroll">
                <%= render_slot(@inner_block) %>
              </div>
            </div>
          </div>
        </.focus_wrap>
      </div>
    </div>
    """
  end

  # TODO The original Phoenix components that conflicts with the one we had.
  #      Kept as part of Phoenix upgrade to dealt with later.

  # @doc """
  #   Renders a modal.

  #   ## Examples

  #       <.modal id="confirm-modal">
  #         This is a modal.
  #       </.modal>

  #   JS commands may be passed to the `:on_cancel` to configure
  #   the closing/cancel event, for example:

  #       <.modal id="confirm" on_cancel={JS.navigate(~p"/posts")}>
  #         This is another modal.
  #       </.modal>

  #   """
  #   attr :id, :string, required: true
  #   attr :show, :boolean, default: false
  #   attr :on_cancel, JS, default: %JS{}
  #   slot :inner_block, required: true

  #   def modal(assigns) do
  #     ~H"""
  #     <div
  #       id={@id}
  #       phx-mounted={@show && show_modal(@id)}
  #       phx-remove={hide_modal(@id)}
  #       data-cancel={JS.exec(@on_cancel, "phx-remove")}
  #       class="relative z-50 hidden"
  #     >
  #       <div id={"#{@id}-bg"} class="bg-zinc-50/90 fixed inset-0 transition-opacity" aria-hidden="true" />
  #       <div
  #         class="fixed inset-0 overflow-y-auto"
  #         aria-labelledby={"#{@id}-title"}
  #         aria-describedby={"#{@id}-description"}
  #         role="dialog"
  #         aria-modal="true"
  #         tabindex="0"
  #       >
  #         <div class="flex min-h-full items-center justify-center">
  #           <div class="w-full max-w-3xl p-4 sm:p-6 lg:py-8">
  #             <.focus_wrap
  #               id={"#{@id}-container"}
  #               phx-window-keydown={JS.exec("data-cancel", to: "##{@id}")}
  #               phx-key="escape"
  #               phx-click-away={JS.exec("data-cancel", to: "##{@id}")}
  #               class="shadow-zinc-700/10 ring-zinc-700/10 relative hidden rounded-2xl bg-white p-14 shadow-lg ring-1 transition"
  #             >
  #               <div class="absolute top-6 right-5">
  #                 <button
  #                   phx-click={JS.exec("data-cancel", to: "##{@id}")}
  #                   type="button"
  #                   class="-m-3 flex-none p-3 opacity-20 hover:opacity-40"
  #                   aria-label={gettext("close")}
  #                 >
  #                   <.icon name="hero-x-mark-solid" class="h-5 w-5" />
  #                 </button>
  #               </div>
  #               <div id={"#{@id}-content"}>
  #                 <%= render_slot(@inner_block) %>
  #               </div>
  #             </.focus_wrap>
  #           </div>
  #         </div>
  #       </div>
  #     </div>
  #     """
  #   end

  defp close_button(assigns \\ %{}) do
    ~H"""
    <button>
      <span class="material-symbols">close</span>
    </button>
    """
  end

  @doc """
  Hides a modal rendered with `modal/1`.
  """
  @spec hide_modal(map()) :: map()
  def hide_modal(js \\ %JS{}) do
    js
    |> JS.hide(to: "#modal", transition: "fade-out")
    |> JS.hide(to: "#modal-content", transition: "fade-out-scale")
  end

  @doc """
  Returns the singular or plural version of `word` based on `count`.

  ## Options

  * `plural` - The plural form of `word`; useful for cases when this is not
               simple to derive, e.g. "studies", "deer"
  """
  @spec pluralize(String.t(), integer(), [{:plural, String.t()}]) :: String.t()
  def pluralize(word, count, opts \\ [])

  def pluralize(word, 1, _opts), do: word

  def pluralize(word, _count, opts) do
    Keyword.get_lazy(opts, :plural, fn -> "#{word}s" end)
  end

  @doc """
  Format a value as a percentage.
  """
  def format_percentage!(%Decimal{} = decimal) do
    decimal
    |> Decimal.to_float()
    |> GratitudeEx.Cldr.Number.to_string!(format: :percent)
  end

  def format_percentage!(float) do
    GratitudeEx.Cldr.Number.to_string!(float, format: :percent)
  end

  @doc """
  Format milliseconds as a human-readable, multi-unit string. If it includes a
  unit larger than seconds, it rounds the number of seconds.

  ## Examples

      iex> GratitudeExWeb.CoreComponents.format_milliseconds!(3455)
      "3.455 sec"

      iex> GratitudeExWeb.CoreComponents.format_milliseconds!(333455)
      "5 min, 33 sec"

      iex> GratitudeExWeb.CoreComponents.format_milliseconds!(33455948484)
      "387 days, 5 hr, 19 min, 8 sec"
  """
  def format_milliseconds!(ms) when is_integer(ms) do
    decomposed =
      ms
      |> GratitudeEx.Cldr.Unit.new!(:millisecond)
      |> GratitudeEx.Cldr.Unit.decompose([:day, :hour, :minute, :second])

    case Enum.count(decomposed) do
      # only seconds - show fraction
      1 ->
        Enum.map_join(decomposed, ", ", fn unit ->
          GratitudeEx.Cldr.Unit.to_string!(unit, style: :short)
        end)

      # units larger than seconds; round fractions of seconds
      _ ->
        Enum.map_join(decomposed, ", ", fn unit ->
          unit
          |> GratitudeEx.Cldr.Unit.round()
          |> GratitudeEx.Cldr.Unit.to_string!(style: :short)
        end)
    end
  end

  @doc """
  Renders flash notices.

  ## Examples

      <.flash kind={:info} flash={@flash} />
      <.flash kind={:info} phx-mounted={show("#flash")}>Welcome Back!</.flash>
  """
  attr :id, :string, default: "flash", doc: "the optional id of flash container"
  attr :flash, :map, default: %{}, doc: "the map of flash messages to display"
  attr :title, :string, default: nil
  attr :kind, :atom, values: [:info, :error], doc: "used for styling and flash lookup"
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the flash container"

  slot :inner_block, doc: "the optional inner block that renders the flash message"

  def flash(assigns) do
    ~H"""
    <div
      :if={msg = render_slot(@inner_block) || Phoenix.Flash.get(@flash, @kind)}
      id={@id}
      phx-click={JS.push("lv:clear-flash", value: %{key: @kind}) |> hide("#flash")}
      role="alert"
      class={[
        "fixed top-2 right-2 w-80 sm:w-96 z-50 rounded-lg p-3 ring-1",
        @kind == :info && "bg-emerald-50 text-emerald-800 ring-emerald-500 fill-cyan-900",
        @kind == :error && "bg-rose-50 text-rose-900 shadow-md ring-rose-500 fill-rose-900"
      ]}
      {@rest}
    >
      <p :if={@title} class="flex items-center gap-1.5 text-sm font-semibold leading-6">
        <%!-- <.icon :if={@kind == :info} name="hero-information-circle-mini" class="h-4 w-4" />
        <.icon :if={@kind == :error} name="hero-exclamation-circle-mini" class="h-4 w-4" /> --%>
        <%= @title %>
      </p>
      <p class="mt-2 text-sm leading-5"><%= msg %></p>
      <button type="button" class="group absolute top-1 right-1 p-2" aria-label={gettext("close")}>
        <%!-- <.icon name="hero-x-mark-solid" class="h-5 w-5 opacity-40 group-hover:opacity-70" /> --%>
      </button>
    </div>
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  def flash_group(assigns) do
    ~H"""
    <.flash kind={:info} title="Success!" flash={@flash} />
    <.flash kind={:error} title="Error!" flash={@flash} />
    <%!-- <.flash
      id="disconnected"
      kind={:error}
      title="We can't find the internet"
      phx-disconnected={show("#disconnected")}
      phx-connected={hide("#disconnected")}
      hidden
    >
      Attempting to reconnect <.icon name="hero-arrow-path" class="ml-1 h-3 w-3 animate-spin" />
    </.flash> --%>
    """
  end

  @doc """
  Renders a simple form.

  ## Examples

      <.simple_form for={@form} phx-change="validate" phx-submit="save">
        <.input field={@form[:email]} label="Email"/>
        <.input field={@form[:username]} label="Username" />
        <:actions>
          <.button>Save</.button>
        </:actions>
      </.simple_form>
  """
  attr :for, :any, required: true, doc: "the datastructure for the form"
  attr :as, :any, default: nil, doc: "the server side parameter to collect all input under"

  attr :rest, :global,
    include: ~w(autocomplete name rel action enctype method novalidate target),
    doc: "the arbitrary HTML attributes to apply to the form tag"

  slot :inner_block, required: true
  slot :actions, doc: "the slot for form actions, such as a submit button"

  def simple_form(assigns) do
    ~H"""
    <.form :let={f} for={@for} as={@as} {@rest}>
      <div class="mt-10 space-y-8 bg-white">
        <%= render_slot(@inner_block, f) %>
        <div :for={action <- @actions} class="mt-2 flex items-center justify-between gap-6">
          <%= render_slot(action, f) %>
        </div>
      </div>
    </.form>
    """
  end

  @doc """
  Renders an input with label and error messages.

  A `%Phoenix.HTML.Form{}` and field name may be passed to the input
  to build input names and error messages, or all the attributes and
  errors may be passed explicitly.

  ## Examples

      <.input field={@form[:email]} type="email" />
      <.input name="my-input" errors={["oh no!"]} />
  """
  attr :id, :any, default: nil
  attr :name, :any
  attr :label, :string, default: nil
  attr :value, :any

  attr :type, :string,
    default: "text",
    values: ~w(checkbox color date datetime-local email auth_email file hidden month number
               password auth_password range radio search select tel text textarea time url week)

  attr :field, Phoenix.HTML.FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :errors, :list, default: []
  attr :checked, :boolean, doc: "the checked flag for checkbox inputs"
  attr :prompt, :string, default: nil, doc: "the prompt for select inputs"
  attr :options, :list, doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2"
  attr :multiple, :boolean, default: false, doc: "the multiple flag for select inputs"
  attr :class, :string, default: nil, doc: "extra classes for the input element"

  attr :input_dimensions_class, :string,
    default: "h-8 w-full",
    doc: "classes for height and width for the input element"

  attr :input_text_class, :string,
    default: "text-xs placeholder:text-xs",
    doc: "classes for text size"

  attr :container_class, :string, default: nil, doc: "extra classes for the container div"
  attr :label_class, :string, default: nil, doc: "extra classes for label, if present"
  attr :disabled, :boolean, default: false

  attr :no_errors, :boolean,
    default: false,
    doc: """
    the errors box takes up space even if no errors are present; this will force the errors box to
    never appear
    """

  attr :rest, :global,
    default: %{"phx-debounce": "blur"},
    include: ~w(autocomplete cols disabled form list max maxlength min minlength
                pattern placeholder readonly required rows size step)

  slot :inner_block

  def input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, Enum.map(field.errors, &translate_error(&1)))
    |> assign_new(:name, fn -> if assigns.multiple, do: field.name <> "[]", else: field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> input()
  end

  def input(%{type: "checkbox", value: value} = assigns) do
    assigns =
      assign_new(assigns, :checked, fn -> Phoenix.HTML.Form.normalize_value("checkbox", value) end)

    ~H"""
    <div phx-feedback-for={@name} class={[@disabled && "opacity-50", @container_class]}>
      <label class={["flex items-center gap-4 text-sm leading-6 text-grey-1000", @label_class]}>
        <input type="hidden" name={@name} value="false" />
        <input
          type="checkbox"
          id={@id}
          name={@name}
          value="true"
          checked={@checked}
          class="rounded border-grey-300 text-grey-1000 focus:ring-grey-1000"
          disabled={@disabled}
          {@rest}
        />
        <%= @label %>
      </label>
      <.error :if={!@no_errors}><%= Enum.join(@errors, ", ") %></.error>
    </div>
    """
  end

  def input(%{type: "select"} = assigns) do
    ~H"""
    <div phx-feedback-for={@name} class={[@disabled && "opacity-50", @container_class, "space-y-2"]}>
      <.label :if={@label} for={@id} class={@label_class}><%= @label %></.label>
      <select
        id={@id}
        name={@name}
        class={[
          "pl-3 py-0 pr-8 block rounded-lg border focus:ring-0 text-grey-1000 placeholder:text-grey-600",
          "phx-no-feedback:border-grey-50 phx-no-feedback:bg-grey-50 phx-no-feedback:focus:bg-white phx-no-feedback:focus:border-grey-100",
          "border-grey-50 bg-grey-50 focus:bg-white focus:border-grey-100",
          @input_text_class,
          @input_dimensions_class,
          @class
        ]}
        multiple={@multiple}
        disabled={@disabled}
        {@rest}
      >
        <option :if={@prompt} value=""><%= @prompt %></option>
        <%= Phoenix.HTML.Form.options_for_select(@options, @value) %>
      </select>
      <.error :if={!@no_errors}><%= Enum.join(@errors, ", ") %></.error>
    </div>
    """
  end

  def input(%{type: "textarea"} = assigns) do
    ~H"""
    <div phx-feedback-for={@name} class={[@disabled && "opacity-50", @container_class, "space-y-2"]}>
      <.label :if={@label} for={@id} class={@label_class}><%= @label %></.label>
      <div class={[
        "rounded-lg p-4 child-focus:bg-white child-focus:ring-1 child-focus:ring-grey-100",
        if(@errors == [],
          do: "bg-grey-50",
          else:
            "bg-white border-vibrant-red-300 ring-1 ring-vibrant-red-300 child-focus:ring-vibrant-red-300"
        )
      ]}>
        <textarea
          id={@id}
          name={@name}
          class={[
            "block min-h-[4rem] w-full border-none focus:outline-none bg-transparent focus:ring-0 p-0 text-grey-1000 placeholder:text-grey-600",
            @input_text_class,
            @class
          ]}
          disabled={@disabled}
          {@rest}
        ><%= Phoenix.HTML.Form.normalize_value("textarea", @value) %></textarea>
      </div>
      <.error :if={!@no_errors}><%= Enum.join(@errors, ", ") %></.error>
    </div>
    """
  end

  # All other inputs text, datetime-local, url, password, etc. are handled below...

  def input(%{type: "search"} = assigns) do
    ~H"""
    <div phx-feedback-for={@name} class={[@disabled && "opacity-50", @container_class, "space-y-2"]}>
      <.label :if={@label} for={@id} class={@label_class}><%= @label %></.label>
      <div class="flex items-center">
        <input
          type={@type}
          name={@name}
          id={@id}
          value={Phoenix.HTML.Form.normalize_value(@type, @value)}
          class={[
            "h-8 peer block w-full rounded-lg text-xs placeholder:text-xs border focus:ring-0 text-grey-1000 placeholder:text-grey-600",
            "phx-no-feedback:border-grey-50 phx-no-feedback:bg-grey-50 phx-no-feedback:focus:bg-white phx-no-feedback:focus:border-grey-100",
            if(@errors == [],
              do: "border-grey-50 bg-grey-50 focus:bg-white focus:border-grey-100",
              else: "bg-white border-vibrant-red-300 focus:border-vibrant-red-300"
            ),
            @class
          ]}
          disabled={@disabled}
          {@rest}
        />
        <%!-- <Icons.search class="peer-placeholder-shown:block hidden h-6 w-6 -ml-8 text-grey-1000" /> --%>
      </div>
    </div>
    """
  end

  # Special inputs for auth pages, e.g. login/registration.
  def input(%{type: "auth_" <> type} = assigns) when type in ["email", "password"] do
    assigns = assign(assigns, :type, type)

    ~H"""
    <div phx-feedback-for={@name} class={[@disabled && "opacity-50", @container_class, "space-y-2"]}>
      <.label :if={@label} for={@id} class={@label_class}><%= @label %></.label>
      <input
        type={@type}
        name={@name}
        id={@id}
        value={Phoenix.HTML.Form.normalize_value(@type, @value)}
        class={[
          "h-12 py-3 px-4 opacity-70 appearance-none antialiased text-sm leading-6",
          "block w-full rounded-md border focus:ring-0 text-vibrant-blue-50 placeholder:text-vibrant-blue-50",
          "phx-no-feedback:border-vibrant-blue-700 phx-no-feedback:bg-vibrant-blue-700 phx-no-feedback:focus:bg-vibrant-blue-600 phx-no-feedback:focus:border-vibrant-blue-50",
          if(@errors == [],
            do:
              "border-vibrant-blue-700 bg-vibrant-blue-700 focus:bg-vibrant-blue-600 focus:border-vibrant-blue-50",
            else: "bg-vibrant-blue-600 border-vibrant-red-300 focus:border-vibrant-red-300"
          ),
          @class
        ]}
        disabled={@disabled}
        {@rest}
      />
      <.error :if={!@no_errors}><%= Enum.join(@errors, ", ") %></.error>
    </div>
    """
  end

  def input(%{type: "password"} = assigns) do
    ~H"""
    <div phx-feedback-for={@name} class={[@disabled && "opacity-50", @container_class, "space-y-2"]}>
      <.label :if={@label} for={@id} class={@label_class}><%= @label %></.label>
      <div class="flex items-center relative">
        <input
          type={@type}
          name={@name}
          id={@id}
          value={Phoenix.HTML.Form.normalize_value(@type, @value)}
          class={[
            "h-8 w-full rounded-lg text-xs placeholder:text-xs border focus:ring-0 text-grey-1000 placeholder:text-grey-600",
            "phx-no-feedback:border-grey-50 phx-no-feedback:bg-grey-50 phx-no-feedback:focus:bg-white phx-no-feedback:focus:border-grey-100",
            if(@errors == [],
              do: "border-grey-50 bg-grey-50 focus:bg-white focus:border-grey-100",
              else: "bg-white border-vibrant-red-300 focus:border-vibrant-red-300"
            ),
            @class
          ]}
          disabled={@disabled}
          {@rest}
        />

        <div id={"show-button-#{@id}"} class="absolute right-0 flex items-center h-8 mr-2">
          <Buttons.icon_button
            icon={:eye}
            type="button"
            color="grey"
            size="small"
            sr_label={gettext("unmask password")}
            phx-click={
              JS.hide(to: "#show-button-#{@id}")
              |> JS.toggle(to: "#hide-button-#{@id}", display: "flex")
              |> JS.set_attribute({"type", "text"}, to: "#" <> @id)
            }
          />
        </div>

        <div id={"hide-button-#{@id}"} class="absolute right-0 hidden items-center h-8 mr-2">
          <Buttons.icon_button
            icon={:eye_hidden}
            type="button"
            color="grey"
            size="small"
            sr_label={gettext("mask password")}
            phx-click={
              JS.hide(to: "#hide-button-#{@id}")
              |> JS.toggle(to: "#show-button-#{@id}", display: "flex")
              |> JS.set_attribute({"type", "password"}, to: "#" <> @id)
            }
          />
        </div>
      </div>
      <.error :if={!@no_errors}><%= Enum.join(@errors, ", ") %></.error>
    </div>
    """
  end

  def input(assigns) do
    ~H"""
    <div phx-feedback-for={@name} class={[@disabled && "opacity-50", @container_class, "space-y-2"]}>
      <.label :if={@label} for={@id} class={@label_class}><%= @label %></.label>
      <input
        type={@type}
        name={@name}
        id={@id}
        value={Phoenix.HTML.Form.normalize_value(@type, @value)}
        class={[
          "block rounded-lg border focus:ring-0 text-grey-1000 placeholder:text-grey-600",
          "phx-no-feedback:border-grey-50 phx-no-feedback:bg-grey-50 phx-no-feedback:focus:bg-white phx-no-feedback:focus:border-grey-100",
          if(@errors == [],
            do: "border-grey-50 bg-grey-50 focus:bg-white focus:border-grey-100",
            else: "bg-white border-vibrant-red-300 focus:border-vibrant-red-300"
          ),
          @input_dimensions_class,
          @input_text_class,
          @class
        ]}
        disabled={@disabled}
        {@rest}
      />
      <.error :if={!(@type == "hidden" || @no_errors)}><%= Enum.join(@errors, ", ") %></.error>
    </div>
    """
  end

  @doc """
  Renders a title and styled container for grouping radio buttons.

  ## Examples

   <.input_radio_button_group title={gettext("Fan Mode")}>
      <.input_radio_button ... />
      <.input_radio_button ... />
      />
    </.input_radio_button_group>

  """
  attr :title, :string, required: true
  attr :slot_container_class, :string, default: "mb-6"
  slot :inner_block, required: true

  def input_radio_button_group(assigns) do
    ~H"""
    <fieldset>
      <legend class="text-xxs mb-2 text-left font-normal leading-4">
        <%= @title %>
      </legend>
      <div class={["flex items-center gap-12", @slot_container_class]}>
        <%= render_slot(@inner_block) %>
      </div>
    </fieldset>
    """
  end

  @doc """
  Renders a radio button with label.

  ## Examples

      <.input_radio_button
        form={@form}
        field={@form[:duct_probe_installed]}
        label={gettext("Yes")}
        value={true}
        id="duct-probe-installed-true"
      />

  """
  attr :form, Phoenix.HTML.Form, doc: "a form struct", required: true

  attr :field, Phoenix.HTML.FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]",
    required: true

  # value is expected to be an atom or string, but there is no way to specify that
  attr :value, :any, required: true
  attr :id, :string, default: nil
  attr :label, :string, required: true

  def input_radio_button(assigns) do
    # use passed-id ID or use the auto-generated ID from the field
    assigns = assign(assigns, :id, assigns.id || assigns.field.id)

    ~H"""
    <label for={@id} class="cursor-pointer">
      <div class="flex items-center gap-2">
        <%!-- <%= if value_selected?(@form, @field.field, @value) do %>
          <Icons.checked_circle class="text-grey-1000 h-6 w-6" />
        <% else %>
          <Icons.unchecked_circle class="text-grey-1000 h-6 w-6" />
        <% end %> --%>
        <p class="text-sm leading-tight"><%= @label %></p>
      </div>
      <%= Phoenix.HTML.Form.radio_button(@form, @field.field, @value,
        checked: value_selected?(@form, @field.field, @value),
        id: @id,
        class: "sr-only"
      ) %>
    </label>
    """
  end

  @spec value_selected?(map(), atom(), atom()) :: boolean()
  defp value_selected?(form, field, value) do
    Changeset.get_field(form.source, field) == value
  end

  @doc """
  Renders a label.
  """
  attr :for, :string, default: nil
  attr :class, :string, default: nil
  slot :inner_block, required: true

  def label(assigns) do
    ~H"""
    <label for={@for} class={["block text-grey-1000 text-xxs leading-normal font-medium", @class]}>
      <%= render_slot(@inner_block) %>
    </label>
    """
  end

  @doc """
  For if you want to have more control over where form field errors are rendered.
  """
  attr :field, Phoenix.HTML.FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :include_field_name, :boolean,
    default: false,
    doc: "Whether to include the name of the field in the error message"

  def field_errors(%{field: field} = assigns) do
    assigns =
      assign(assigns,
        errors: Enum.map(field.errors, &translate_error(&1)),
        prefix:
          if(assigns.include_field_name,
            do: assigns.field.field |> to_string() |> String.capitalize()
          )
      )

    ~H"""
    <.error :for={msg <- @errors}>
      <%= @prefix %>
      <%= msg %>
    </.error>
    """
  end

  @doc """
  Generates a generic error message.

  The container always takes up the space it would, regardless of if content is
  passed in or not. It prevents word-wrapping and clips any overflow with
  ellipses.
  """
  slot :inner_block, required: true

  def error(assigns) do
    ~H"""
    <p class="phx-no-feedback:invisible text-xxs font-semibold leading-4 text-vibrant-red-300
              whitespace-nowrap overflow-clip overflow-ellipsis">
      <%= render_slot(@inner_block) %>&ZeroWidthSpace;
    </p>
    """
  end

  @doc """
  Renders a header with title.
  """
  attr :class, :string, default: nil

  slot :inner_block, required: true
  slot :subtitle
  slot :actions

  def header(assigns) do
    ~H"""
    <header class={[@actions != [] && "flex items-center justify-between gap-6", @class]}>
      <div>
        <h1 class="text-lg font-semibold leading-8 text-zinc-800">
          <%= render_slot(@inner_block) %>
        </h1>
        <p :if={@subtitle != []} class="mt-2 text-sm leading-6 text-zinc-600">
          <%= render_slot(@subtitle) %>
        </p>
      </div>
      <div class="flex-none"><%= render_slot(@actions) %></div>
    </header>
    """
  end

  @doc ~S"""
  Renders a table with generic styling.

  ## Examples

      <.table id="users" rows={@users}>
        <:col :let={user} label="id"><%= user.id %></:col>
        <:col :let={user} label="username"><%= user.username %></:col>
      </.table>
  """
  attr :id, :string, required: true
  attr :row_click, :any, default: nil
  attr :rows, :list, required: true

  slot :col, required: true do
    attr :label, :string
  end

  slot :action, doc: "the slot for showing user actions in the last table column"

  def table(assigns) do
    ~H"""
    <div id={@id} class="overflow-y-auto px-4 sm:overflow-visible sm:px-0">
      <table class="w-[40rem] mt-11 sm:w-full">
        <thead class="text-sm text-left leading-6 text-zinc-500">
          <tr>
            <th :for={col <- @col} class="p-0 pr-6 pb-4 font-normal"><%= col[:label] %></th>
            <th class="relative p-0 pb-4"><span class="sr-only"><%= gettext("Actions") %></span></th>
          </tr>
        </thead>
        <tbody class="relative divide-y divide-zinc-100 border-t border-zinc-200 text-sm leading-6 text-zinc-700">
          <tr
            :for={row <- @rows}
            id={"#{@id}-#{Phoenix.Param.to_param(row)}"}
            class="relative group hover:bg-zinc-50"
          >
            <td
              :for={{col, i} <- Enum.with_index(@col)}
              phx-click={@row_click && @row_click.(row)}
              class={["p-0", @row_click && "hover:cursor-pointer"]}
            >
              <div :if={i == 0}>
                <span class="absolute h-full w-4 top-0 -left-4 group-hover:bg-zinc-50 sm:rounded-l-xl" />
                <span class="absolute h-full w-4 top-0 -right-4 group-hover:bg-zinc-50 sm:rounded-r-xl" />
              </div>
              <div class="block py-4 pr-6">
                <span class={["relative", i == 0 && "font-semibold text-zinc-900"]}>
                  <%= render_slot(col, row) %>
                </span>
              </div>
            </td>
            <td :if={@action != []} class="p-0 w-14">
              <div class="relative whitespace-nowrap py-4 text-right text-sm font-medium">
                <span
                  :for={action <- @action}
                  class="relative ml-4 font-semibold leading-6 text-zinc-900 hover:text-zinc-700"
                >
                  <%= render_slot(action, row) %>
                </span>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end

  @doc """
  Renders a data list.

  ## Examples

      <.list>
        <:item title="Title"><%= @post.title %></:item>
        <:item title="Views"><%= @post.views %></:item>
      </.list>
  """
  slot :item, required: true do
    attr :title, :string, required: true
  end

  def list(assigns) do
    ~H"""
    <div class="mt-14">
      <dl class="-my-4 divide-y divide-zinc-100">
        <div :for={item <- @item} class="flex gap-4 py-4 text-sm leading-6 sm:gap-8">
          <dt class="w-1/4 flex-none text-zinc-500"><%= item.title %></dt>
          <dd class="text-zinc-700"><%= render_slot(item) %></dd>
        </div>
      </dl>
    </div>
    """
  end

  @doc """
  Renders a back navigation link.

  ## Examples

      <.back navigate={~p"/posts"}>Back to posts</.back>
  """
  attr :navigate, :any, required: true
  slot :inner_block, required: true

  def back(assigns) do
    ~H"""
    <div class="mt-16">
      <.link
        navigate={@navigate}
        class="text-sm font-semibold leading-6 text-zinc-900 hover:text-zinc-700"
      >
        <.icon name="hero-arrow-left-solid" class="h-3 w-3" />
        <%= render_slot(@inner_block) %>
      </.link>
    </div>
    """
  end

  @doc """
  Renders a [Hero Icon](https://heroicons.com).

  Hero icons come in three styles – outline, solid, and mini.
  By default, the outline style is used, but solid an mini may
  be applied by using the `-solid` and `-mini` suffix.

  You can customize the size and colors of the icons by setting
  width, height, and background color classes.

  Icons are extracted from your `assets/vendor/heroicons` directory and bundled
  within your compiled app.css by the plugin in your `assets/tailwind.config.js`.

  ## Examples

      <.icon name="hero-x-mark-solid" />
      <.icon name="hero-arrow-path" class="ml-1 w-3 h-3 animate-spin" />
  """
  attr :name, :string, required: true
  attr :class, :string, default: nil

  def icon(%{name: "hero-" <> _} = assigns) do
    ~H"""
    <span class={[@name, @class]} />
    """
  end

  ## JS Commands

  def show(js \\ %JS{}, selector), do: JS.show(js, to: selector, transition: transition_in())
  def hide(js \\ %JS{}, selector), do: JS.hide(js, to: selector, transition: transition_out())

  def toggle(js \\ %JS{}, selector) do
    JS.toggle(js, to: selector, in: transition_in(), out: transition_out())
  end

  defp transition_in() do
    {"transition-all transform ease-out duration-300",
     "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95",
     "opacity-100 translate-y-0 sm:scale-100"}
  end

  defp transition_out() do
    {"transition-all transform ease-in duration-200", "opacity-100 translate-y-0 sm:scale-100",
     "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"}
  end

  def show_modal(js \\ %JS{}, id) when is_binary(id) do
    js
    |> JS.show(to: "##{id}")
    |> JS.show(
      to: "##{id}-bg",
      transition: {"transition-all transform ease-out duration-300", "opacity-0", "opacity-100"}
    )
    |> show("##{id}-container")
    |> JS.focus_first(to: "##{id}-content")
  end

  # TODO The original Phoenix components that conflicts with the one we had.
  #      Kept as part of Phoenix upgrade to dealt with later.

  # def hide_modal(js \\ %JS{}, id) do
  #   js
  #   |> JS.hide(
  #     to: "##{id}-bg",
  #     transition: {"transition-all transform ease-in duration-200", "opacity-100", "opacity-0"}
  #   )
  #   |> hide("##{id}-container")
  #   |> JS.hide(to: "##{id}", transition: {"block", "block", "hidden"})
  #   |> JS.pop_focus()
  # end

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, opts}) do
    # When using gettext, we typically pass the strings we want
    # to translate as a static argument:
    #
    #     # Translate the number of files with plural rules
    #     dngettext("errors", "1 file", "%{count} files", count)
    #
    # However the error messages in our forms and APIs are generated
    # dynamically, so we need to translate them by calling Gettext
    # with our gettext backend as first argument. Translations are
    # available in the errors.po file (as we use the "errors" domain).
    if count = opts[:count] do
      Gettext.dngettext(GratitudeExWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(GratitudeExWeb.Gettext, "errors", msg, opts)
    end
  end

  @doc """
  Translates the errors for a field from a keyword list of errors.
  """
  def translate_errors(errors, field) when is_list(errors) do
    for {^field, {msg, opts}} <- errors, do: translate_error({msg, opts})
  end

  @doc """
  Renders a loading spinner that can be overriden with an optional passed `class` attribute.
  """
  attr :class, :any

  def spinner(assigns) do
    ~H"""
    <div class={[
      "w-5 h-5 border-transparent border-b-grey-1000 border-[3px] animate-spin [border-radius:50%] box-border inline-block",
      @class
    ]}>
    </div>
    """
  end

  def logo_with_text(assigns) do
    ~H"""
    <svg width="249" height="38" viewBox="0 0 249 38" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path
        d="M71.4442 13.8247C70.702 12.457 69.6864 11.414 68.3876 10.6957C67.0888 9.97746 65.5849 9.62324 63.8564 9.62324C61.9424 9.62324 60.253 10.0562 58.7686 10.9319C57.2843 11.8076 56.1319 13.0474 55.3019 14.6709C54.4718 16.2944 54.0519 18.1541 54.0519 20.2794C54.0519 22.4047 54.4718 24.3628 55.3019 25.9764C56.1612 27.5999 57.3526 28.8397 58.8663 29.7154C60.3799 30.5911 62.1377 31.0241 64.1396 31.0241C66.6103 31.0241 68.622 30.3747 70.1942 29.066C71.7665 27.7278 72.8016 25.878 73.2899 23.5067H62.1865V18.5083H79.6667V24.2053C79.237 26.4782 78.3093 28.5839 76.8933 30.5124C75.4773 32.441 73.6414 33.9956 71.3856 35.1862C69.1688 36.3374 66.6689 36.9179 63.8955 36.9179C60.7803 36.9179 57.9581 36.2193 55.4288 34.8123C52.9289 33.3757 50.9562 31.398 49.511 28.8791C48.095 26.3602 47.3821 23.487 47.3821 20.2794C47.3821 17.0717 48.095 14.2084 49.511 11.6895C50.9562 9.13127 52.9289 7.16337 55.4288 5.75633C57.9581 4.31977 60.7608 3.61133 63.8467 3.61133C67.4892 3.61133 70.6434 4.51656 73.3289 6.31718C76.0144 8.08828 77.8601 10.5973 78.8757 13.8345H71.4344L71.4442 13.8247Z"
        fill="white"
      />
      <path
        d="M89.7349 14.7596C90.565 13.3919 91.6489 12.3194 92.977 11.5322C94.3344 10.7549 95.8774 10.3613 97.6059 10.3613V17.2293H95.8969C93.8657 17.2293 92.3227 17.7114 91.2681 18.6757C90.2525 19.6399 89.7447 21.3225 89.7447 23.7233V36.613H83.2701V10.7451H89.7447V14.7596H89.7349Z"
        fill="white"
      />
      <path
        d="M107.127 10.7446V36.6224H100.653V10.7446H107.127ZM103.934 7.66487C102.791 7.66487 101.834 7.31065 101.063 6.59237C100.321 5.84457 99.9496 4.9295 99.9496 3.83732C99.9496 2.74514 100.321 1.83991 101.063 1.13146C101.834 0.383665 102.791 0.00976562 103.934 0.00976562C105.076 0.00976562 106.014 0.383665 106.756 1.13146C107.528 1.84975 107.908 2.75498 107.908 3.83732C107.908 4.91966 107.528 5.84457 106.756 6.59237C106.014 7.31065 105.076 7.66487 103.934 7.66487Z"
        fill="white"
      />
      <path
        d="M130.808 23.6838C130.808 22.0996 130.496 20.7418 129.881 19.6201C129.266 18.4689 128.435 17.5932 127.381 17.0028C126.336 16.3829 125.203 16.068 124.002 16.068C122.801 16.068 121.688 16.3632 120.672 16.9536C119.656 17.544 118.826 18.4197 118.172 19.5709C117.557 20.6926 117.244 22.0307 117.244 23.5854C117.244 25.14 117.557 26.5077 118.172 27.6983C118.816 28.8495 119.656 29.735 120.672 30.3648C121.717 30.9847 122.83 31.2995 124.002 31.2995C125.174 31.2995 126.326 31.0043 127.381 30.414C128.426 29.7941 129.266 28.9184 129.881 27.7967C130.496 26.6455 130.808 25.2778 130.808 23.6838ZM110.643 23.5854C110.643 20.9681 111.151 18.646 112.166 16.6289C113.211 14.602 114.637 13.0473 116.424 11.9551C118.211 10.863 120.203 10.3218 122.391 10.3218C124.051 10.3218 125.643 10.6957 127.156 11.4435C128.67 12.1618 129.871 13.126 130.76 14.3363V2.05664H137.322V36.6227H130.76V32.7951C129.959 34.0743 128.836 35.0976 127.381 35.8749C125.935 36.6522 124.256 37.0458 122.342 37.0458C120.184 37.0458 118.211 36.4849 116.424 35.3632C114.637 34.2415 113.221 32.6672 112.166 30.6501C111.151 28.5937 110.643 26.242 110.643 23.5952V23.5854Z"
        fill="white"
      />
      <path
        d="M153.865 18.823C155.652 18.823 156.98 18.4196 157.839 17.6128C158.699 16.7764 159.138 15.6055 159.138 14.1099C159.138 10.9318 157.38 9.34764 153.865 9.34764H148.728V18.8329H153.865V18.823ZM165.798 14.1099C165.798 15.8515 165.378 17.4849 164.548 19.01C163.747 20.5351 162.468 21.765 160.71 22.6998C158.982 23.6345 156.794 24.097 154.148 24.097H148.738V36.6128H142.263V4.01465H154.148C156.648 4.01465 158.777 4.44758 160.535 5.3233C162.292 6.19901 163.601 7.38958 164.47 8.92454C165.368 10.4497 165.808 12.1814 165.808 14.1099H165.798Z"
        fill="white"
      />
      <path
        d="M180.105 31.3384C181.276 31.3384 182.37 31.0629 183.386 30.502C184.431 29.9117 185.271 29.0359 185.886 27.8847C186.501 26.7335 186.813 25.3265 186.813 23.6833C186.813 21.2234 186.169 19.3342 184.87 18.0354C183.61 16.6973 182.048 16.0282 180.202 16.0282C178.357 16.0282 176.794 16.6973 175.534 18.0354C174.304 19.3441 173.689 21.2234 173.689 23.6833C173.689 26.1431 174.294 28.0422 175.495 29.3803C176.726 30.689 178.269 31.3384 180.124 31.3384H180.105ZM180.105 37.0354C177.634 37.0354 175.417 36.4943 173.445 35.4021C171.472 34.2804 169.919 32.7061 168.777 30.689C167.663 28.662 167.117 26.3301 167.117 23.6833C167.117 21.0365 167.683 18.7045 168.825 16.6776C169.997 14.6507 171.589 13.096 173.591 12.0038C175.593 10.8821 177.829 10.3213 180.3 10.3213C182.771 10.3213 184.997 10.8821 187.009 12.0038C189.011 13.096 190.583 14.6507 191.726 16.6776C192.897 18.7045 193.483 21.0365 193.483 23.6833C193.483 26.3301 192.878 28.662 191.677 30.689C190.505 32.7159 188.903 34.2902 186.862 35.4021C184.86 36.4943 182.605 37.0354 180.114 37.0354H180.105Z"
        fill="white"
      />
      <path
        d="M203.024 10.7446V36.6224H196.55V10.7446H203.024ZM199.831 7.66487C198.688 7.66487 197.731 7.31065 196.96 6.59237C196.218 5.84457 195.846 4.9295 195.846 3.83732C195.846 2.74514 196.218 1.83991 196.96 1.13146C197.731 0.383665 198.688 0.00976562 199.831 0.00976562C200.973 0.00976562 201.911 0.383665 202.653 1.13146C203.425 1.84975 203.805 2.75498 203.805 3.83732C203.805 4.91966 203.425 5.84457 202.653 6.59237C201.911 7.31065 200.973 7.66487 199.831 7.66487Z"
        fill="white"
      />
      <path
        d="M221.481 10.3711C224.537 10.3711 226.998 11.355 228.883 13.3131C230.768 15.2416 231.705 17.9573 231.705 21.4405V36.6228H225.231V22.326C225.231 20.2696 224.723 18.6953 223.707 17.6129C222.692 16.4912 221.305 15.9304 219.547 15.9304C217.79 15.9304 216.344 16.4912 215.29 17.6129C214.274 18.7051 213.766 20.2794 213.766 22.326V36.6228H207.292V10.745H213.766V13.9723C214.625 12.8506 215.719 11.9749 217.047 11.355C218.405 10.7056 219.879 10.3711 221.491 10.3711H221.481Z"
        fill="white"
      />
      <path
        d="M243.268 16.1167V28.6325C243.268 29.5082 243.473 30.1379 243.873 30.5512C244.303 30.9251 245.016 31.112 246.002 31.112H249.01V36.6221H244.938C239.479 36.6221 236.754 33.9458 236.754 28.5833V16.1069H233.698V10.7345H236.754V4.33887H243.277V10.7345H249.01V16.1069H243.277L243.268 16.1167Z"
        fill="white"
      />
      <path
        d="M5.05649 3.83632C4.14319 2.90446 2.65308 2.89503 1.72823 3.81524C0.803386 4.73546 0.794024 6.23686 1.70732 7.16872L10.5726 16.2142C11.4859 17.146 12.9761 17.1555 13.9009 16.2352C14.8258 15.315 14.8351 13.8136 13.9218 12.8818L5.05649 3.83632Z"
        fill="#00FFB3"
      />
      <path
        fill-rule="evenodd"
        clip-rule="evenodd"
        d="M0.58591 15.4967C0.0585741 17.5138 -0.12697 19.6588 0.0878705 21.8924C0.90817 30.2756 7.61705 37.055 15.9372 37.9012C27.2164 39.0524 36.6303 29.5671 35.4779 18.2026C34.6381 9.82917 27.9195 3.0793 19.6091 2.24295C17.3923 2.01664 15.2439 2.21343 13.2322 2.74476C11.4451 3.21705 10.8592 5.48013 12.1482 6.79862C12.7635 7.42834 13.6716 7.64481 14.5212 7.42834C15.9763 7.0446 17.529 6.91669 19.1403 7.08396C25.0484 7.69401 29.8823 12.4268 30.6343 18.36C31.7085 26.9105 24.5797 34.0933 16.0935 33.0208C10.2049 32.273 5.50771 27.4123 4.89248 21.4594C4.72647 19.8359 4.85342 18.2616 5.23427 16.7955C5.44911 15.9493 5.23427 15.0539 4.62881 14.4242C3.32024 13.0959 1.05465 13.6764 0.576144 15.4869L0.58591 15.4967Z"
        fill="#00FFB3"
      />
    </svg>
    """
  end
end
