defmodule GatherWeb.Components do
  use Phoenix.Component

  alias GatherWeb.CoreComponents

  @doc """
  Renders a delete_guest_modal.

  ## Examples

      <.modal guest_id="1" guest_name="Jane Doe" />

  """

  attr :guest_name, :string, required: true
  attr :guest_id, :string, required: true

  def delete_guest_modal(assigns) do
    ~H"""
    <div class="text-left">
      <CoreComponents.modal id={"delete_guest_modal_#{@guest_id}"}>
        <h1 class="text-lg font-medium text-gray-100">Delete <%= @guest_name %>?</h1>
        <p class="mt-2 text-sm"></p>

        <div class="mt-4 flex justify-end space-x-4">
          <button
            phx-click={CoreComponents.hide_modal("delete_guest_modal_#{@guest_id}")}
            class="text-gray-100 hover:text-gray-200"
          >
            Cancel
          </button>
          <button
            phx-click="delete"
            phx-value-id={@guest_id}
            class="text-rose-200 bg-rose-700 hover:bg-rose-800 px-4 py-2 rounded-md"
          >
            Delete
          </button>
        </div>
      </CoreComponents.modal>
    </div>
    """
  end

  attr :label, :string, required: true
  attr :color, :string, default: "gray"

  attr :colors, :map,
    default: %{
      "green" => "bg-emerald-500/10 text-emerald-400 ring-emerald-500/20",
      "red" => "bg-rose-500/10 text-rose-400 ring-rose-500/20"
    }

  def badge(assigns) do
    ~H"""
    <span class={[
      "inline-flex items-center rounded-md px-2 py-1 text-xs font-medium ring-1 ring-inset",
      @colors[@color]
    ]}>
      <%= @label %>
    </span>
    """
  end
end
