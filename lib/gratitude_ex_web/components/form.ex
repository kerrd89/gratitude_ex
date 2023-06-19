defmodule GratitudeExWeb.Components.Form do
  @moduledoc """
  Reusable Form components.
  """
  use Phoenix.Component
  import Phoenix.HTML.Form
  import GratitudeExWeb.ErrorHelpers

  @doc """
  An input_group is the grouping of label, input and error tag.

  They take the following props:
  * Form
  * Field
  * Required: boolean
  * Label: The label text
  * Size: "xs", "sm", "md" or "lg"
  * Color: "primary", "secondary", "accent", "warning", or "error"

  """
  def input_group(%{type: :checkbox} = assigns) do
    assigns =
      assigns
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:size, fn -> "md" end)
      |> assign_new(:color, fn -> nil end)
      |> assign_new(:color_class, fn ->
        if(color = Map.get(assigns, :color), do: checkbox_color(color), else: "")
      end)

    ~H"""
    <div class={["flex items-center space-x-2", @class]}>
      <%= checkbox(@form, @field,
        class: "checkbox #{checkbox_size(@size)} #{@color_class} #{@input_class}"
      ) %>
      <%= if @label do %>
        <%= label @form, @field, class: "label relative" do %>
          <span class={"text-grey-700 text-sm #{@label_class}"}>
            <%= @label %>
            <%= required_indicator(assigns) %>
          </span>
        <% end %>
      <% end %>
    </div>
    """
  end

  def input_group(%{type: :select} = assigns) do
    assigns =
      assigns
      |> assign_new(:type, fn -> :text end)
      |> assign_new(:label, fn -> nil end)
      |> assign_new(:label_class, fn -> nil end)
      |> assign_new(:color, fn -> nil end)
      |> assign_new(:size, fn -> nil end)
      |> assign_new(:input_class, fn -> nil end)
      |> assign_new(:class, fn -> "input" end)
      |> assign_new(:prompt, fn -> "Select" end)
      |> assign_new(:disabled, fn -> false end)
      |> assign_new(:required, fn -> false end)
      |> assign_new(:show_error_text, fn -> true end)
      |> assign_new(:selected, fn -> nil end)

    field_errors = field_errors(assigns.form, assigns.field)
    error_class = if Enum.empty?(field_errors), do: nil, else: "input-error"

    input_class = [
      error_class,
      # color_class,
      # size_class,
      assigns.input_class
    ]

    assigns =
      if assigns.disabled do
        assign(assigns, :input_class, [disabled_text_class() | input_class])
      else
        assigns
      end

    ~H"""
    <div class={@class}>
      <%= if @label do %>
        <%= label @form, @field, class: "label relative" do %>
          <span class={"text-grey-1000 text-sm #{if assigns.disabled, do: disabled_text_class()} #{@label_class}"}>
            <%= @label %>
            <%= required_indicator(assigns) %>
          </span>
        <% end %>
      <% end %>
      <%= select(
        @form,
        @field,
        @options,
        class: @input_class,
        prompt: @prompt,
        disabled: @disabled,
        selected: @selected
      ) %>
      <%= if @show_error_text do %>
        <%= error_tag(@form, @field) %>
      <% end %>
    </div>
    """
  end

  def input_group(assigns) do
    assigns =
      assigns
      |> assign_new(:type, fn -> :text end)
      |> assign_new(:label, fn -> nil end)
      |> assign_new(:label_class, fn -> nil end)
      |> assign_new(:color, fn -> nil end)
      |> assign_new(:size, fn -> nil end)
      |> assign_new(:input_class, fn -> nil end)
      |> assign_new(:class, fn -> nil end)
      |> assign_new(:disabled, fn -> false end)
      |> assign_new(:show_error_text, fn -> true end)
      |> assign_new(:error_class, fn -> nil end)
      |> assign_new(:required, fn -> false end)
      |> assign_new(:format, fn -> nil end)

    field_errors = field_errors(assigns.form, assigns.field)

    error_class =
      cond do
        Map.get(assigns, :error_class) -> assigns.error_class
        Enum.empty?(field_errors) -> nil
        :else -> "input-error"
      end

    color_class = if color = assigns.color, do: input_color(color), else: nil
    size_class = if size = assigns.size, do: input_size(size), else: nil

    extra_input_attrs =
      assigns_to_attributes(assigns, [
        :form,
        :field,
        :type,
        :label,
        :color,
        :size,
        :input_class,
        :class
      ])

    input_class = [
      error_class,
      color_class,
      size_class,
      assigns.input_class
    ]

    input_class =
      if assigns.disabled do
        [disabled_text_class() | input_class]
      else
        input_class
      end

    assigns =
      assigns
      |> assign(:input_class, input_class)
      |> assign(:extra_input_attrs, extra_input_attrs)

    ~H"""
    <div class={@class}>
      <%= if @label do %>
        <%= label @form, @field, class: "label relative" do %>
          <span class={"text-grey-1000 text-sm #{if assigns.disabled, do: disabled_text_class()} #{@label_class}"}>
            <%= @label %>
            <%= required_indicator(assigns) %>
          </span>
        <% end %>
      <% end %>
      <%= input_tag(@type, @form, @field, [class: @input_class] ++ @extra_input_attrs) %>
      <%= if @show_error_text do %>
        <%= error_tag(@form, @field) %>
      <% end %>
    </div>
    """
  end

  def required_indicator(%{required: true} = assigns) do
    ~H"""
    <span class="sr-only">(Required)</span>
    <span class="absolute top right text-xs font-medium after:content-['*']"></span>
    """
  end

  def required_indicator(_assigns), do: nil

  def input_tag(:date, form, field, opts) do
    date_input(form, field, opts)
  end

  def input_tag(:text, form, field, opts) do
    text_input(form, field, opts)
  end

  def input_tag(:number, form, field, opts) do
    number_input(form, field, opts)
  end

  def input_tag(:phone_number, form, field, opts) do
    telephone_input(
      form,
      field,
      Keyword.put(
        opts,
        :value,
        Number.Phone.number_to_phone(input_value(form, field), area_code: true)
      )
    )
  end

  def input_tag(:select, form, field, opts) do
    select(form, field, opts)
  end

  def input_tag(:email, form, field, opts) do
    email_input(form, field, opts)
  end

  def input_tag(:password, form, field, opts) do
    password_input(form, field, opts)
  end

  def input_tag(:checkbox, form, field, opts) do
    checkbox(form, field, opts)
  end

  @doc """
  Returns the set of HTML classes for text inputs rendered in the
  unauthenticated layout.
  """
  @spec auth_input_class(String.t()) :: [String.t()]
  def auth_input_class(rest \\ "") do
    [
      """
      w-full py-3 px-4
      border border-vibrant-blue-700
      rounded-md opacity-70 appearance-none
      antialiased text-sm leading-6

      text-vibrant-blue-50

      bg-vibrant-blue-700
      focus:bg-vibrant-blue-600

      focus:outline-none
      focus:border-vibrant-blue-50
      focus:ring-0

      placeholder:text-vibrant-blue-50
      focus:placeholder-vibrant-blue-100
      """,
      rest
    ]
  end

  # Due to the Tailwind compiler, it is important that the full string of class names
  # appears in this file, so we cannot use interpolation
  defp checkbox_color("primary"), do: "checkbox-primary"
  defp checkbox_color("secondary"), do: "checkbox-secondary"
  defp checkbox_color("warning"), do: "checkbox-warning"
  defp checkbox_color("accent"), do: "checkbox-accent"
  defp checkbox_color("error"), do: "checkbox-error"

  defp input_color("primary"), do: "input-primary"
  defp input_color("secondary"), do: "input-secondary"
  defp input_color("warning"), do: "input-warning"
  defp input_color("accent"), do: "input-accent"
  defp input_color("error"), do: "input-error"

  defp checkbox_size("xs"), do: "checkbox-xs"
  defp checkbox_size("sm"), do: "checkbox-sm"
  defp checkbox_size("md"), do: "checkbox-md"
  defp checkbox_size("lg"), do: "checkbox-lg"

  defp input_size("xs"), do: "input-xs"
  defp input_size("sm"), do: "input-sm"
  defp input_size("md"), do: "input-md"
  defp input_size("lg"), do: "input-lg"

  defp disabled_text_class, do: "opacity-disabled"
end
