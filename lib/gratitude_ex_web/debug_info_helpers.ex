defmodule GratitudeExWeb.DebugInfoHelpers do
  @moduledoc """
  Helpers to manage displaying debug info.
  """

  @doc """
  Returns a map based on the current environment.
  In the case of prod or any other environments, we don't display any
  information so nil is returned.
  """
  @spec get_debug_info() :: DebugInfo.t() | nil
  def get_debug_info() do
    env_name = Application.get_env(:gratitude_ex, :environment)

    case env_name do
      "dev" ->
        %{
          env_name: "Dev",
          bg_color: "bg-[#FFEB85]",
          text_color: "text-[#C88401]",
          light_t_border_color: "border-t-[#FFEB85]",
          dark_t_border_color: "border-t-[#C88401]"
        }

      "staging" ->
        %{
          env_name: "Staging",
          bg_color: "bg-[#FFD7F6]",
          text_color: "text-[#FF00C7]",
          light_t_border_color: "border-t-[#FFD7F6]",
          dark_t_border_color: "border-t-[#FF00C7]"
        }

      "pr_preview" ->
        %{
          env_name: "PR",
          bg_color: "bg-[#E9FFD7]",
          text_color: "text-[#70C801]",
          light_t_border_color: "border-t-[#E9FFD7]",
          dark_t_border_color: "border-t-[#70C801]"
        }

      "demo" ->
        %{
          env_name: "Demo",
          bg_color: "bg-[#FFD7F6]",
          text_color: "text-[#FF00C7]",
          light_t_border_color: "border-t-[#FFD7F6]",
          dark_t_border_color: "border-t-[#FF00C7]"
        }

      _ ->
        nil
    end
  end
end
