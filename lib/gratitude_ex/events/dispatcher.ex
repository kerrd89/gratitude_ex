defmodule GratitudeEx.Events.Dispatcher do
  @moduledoc """
  An event dispatcher is an Oban job which schedules 1-n jobs to handle the event.
  """

  @callback handlers() :: [module()]

  @doc false
  defmacro __using__(_opts) do
    quote do
      use Oban.Worker
      @behaviour unquote(__MODULE__)

      def dispatch(params) do
        params
        |> new()
        |> Oban.insert()
      end

      def perform(%Oban.Job{args: args}) when is_struct(args) do
        args
        # If using `args_schema`, the args are a struct
        # which cannot be serialized for handler jobs
        |> Map.from_struct()
        |> do_perform()
      end

      def perform(%Oban.Job{args: args}) when is_map(args) do
        do_perform(args)
      end

      defp do_perform(handler_args) do
        jobs =
          handlers()
          |> Enum.map(& &1.new(handler_args))
          |> Oban.insert_all()

        {:ok, jobs}
      end
    end
  end
end
