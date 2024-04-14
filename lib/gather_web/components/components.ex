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
      <CoreComponents.modal id="delete_guest_modal">
        <h1 class="text-lg font-medium text-gray-100">Delete <%= @guest_name %></h1>
        <p class="mt-2 text-sm"></p>

        <div class="mt-4 flex justify-end space-x-4">
          <button
            phx-click={CoreComponents.hide_modal("delete_guest_modal")}
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
end
