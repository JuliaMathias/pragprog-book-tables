defmodule MeowWeb.MeerkatSortingLive do
  use MeowWeb, :live_view

  alias Meow.Meerkats
  alias MeowWeb

  def mount(_params, _session, socket), do: {:ok, socket}

  def handle_params(params, _url, socket) do
    socket =
      socket
      |> parse_params(params)
      |> assign_meerkats()

    {:noreply, socket}
  end

  def handle_info({:update, opts}, socket) do
    path = Routes.live_path(socket, __MODULE__, opts)
    {:noreply, push_patch(socket, to: path, replace: true)}
  end

  defp parse_params(socket, params) do
    case SortingForm.parse(params) do
      {:ok, sorting_opts} ->
        assign_sorting(socket, sorting_opts)

      {:error, %Ecto.Changeset{} = _changeset} ->
        assign_sorting(socket)
    end
  end

  defp assign_meerkats(socket) do
    %{sorting: sorting} = socket.assigns

    assign(socket, :meerkats, Meerkats.list_meerkats(sorting))
  end

  defp assign_sorting(socket, overrides \\ %{}) do
    opts = Map.merge(SortingForm.default_values(), overrides)
    assign(socket, :sorting, opts)
  end
end
