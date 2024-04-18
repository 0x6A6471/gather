defmodule GatherWeb.GuestsEditLive do
  use GatherWeb, :live_view

  alias Gather.Guests
  alias Gather.Guests.Guest

  def render(assigns) do
    ~H"""
    <div class="max-w-screen-md mx-auto bg-gray-900/80 rounded-lg p-8">
      <.form for={@form} id="edit_guest_form" phx-submit="update" phx-change="validate">
        <h1 class="text-3xl font-bold leading-7 text-center text-gray-100">
          Edit <%= @guest.name %>
        </h1>

        <div class="mt-10 grid grid-cols-1 gap-6 sm:grid-cols-6">
          <div class="sm:col-span-3">
            <.input
              field={@form[:name]}
              type="text"
              label="Name"
              placeholder="Jane & John Doe"
              required
              autofocus
            />
          </div>
          <div class="sm:col-span-3">
            <.input
              field={@form[:guest_amount]}
              min="1"
              type="number"
              label="Guest amount"
              required
              autofocus
            />
          </div>

          <div class="sm:col-span-3">
            <.input
              field={@form[:address_line_1]}
              type="text"
              label="Street address"
              placeholder="123 Main St."
              required
            />
          </div>

          <div class="sm:col-span-3">
            <.input
              field={@form[:address_line_2]}
              type="text"
              label="Address line 2"
              placeholder="Apt 802"
            />
          </div>

          <div class="sm:col-span-2 sm:col-start-1">
            <.input field={@form[:city]} type="text" label="City" placeholder="Boston" required />
          </div>

          <div class="sm:col-span-2">
            <.input
              field={@form[:state]}
              type="select"
              label="State"
              placeholder="MA"
              required
              options={@states}
            />
          </div>

          <div class="sm:col-span-2">
            <.input
              field={@form[:zip]}
              type="text"
              maxlength="5"
              label="Postal code"
              placeholder="02111"
              required
              phx-debounce="blur"
            />
          </div>
        </div>

        <fieldset>
          <div class="mt-6 space-y-6">
            <div class="relative flex gap-x-3">
              <.input field={@form[:save_the_date_sent]} type="checkbox" label="Save the Date Sent" />
            </div>
            <div class="relative flex gap-x-3">
              <.input field={@form[:rsvp_sent]} type="checkbox" label="RSVP Sent" />
            </div>
            <div class="relative flex gap-x-3">
              <.input field={@form[:invite_sent]} type="checkbox" label="Invite Sent" />
            </div>
          </div>
        </fieldset>

        <div class="mt-6 flex items-center justify-end gap-x-6">
          <a href="/guests" class="text-sm font-medium leading-6 text-gray-100 hover:text-gray-300">
            Cancel
          </a>
          <.button type="submit" phx-disable-with="Saving...">
            Save
          </.button>
        </div>
      </.form>
    </div>
    """
  end

  def mount(%{"id" => id}, _session, socket) do
    guest = Guests.get_guest!(id)
    changeset = Guests.change_guest(guest)

    {:ok,
     assign(socket,
       states: Guests.list_states(),
       form: to_form(changeset),
       guest: guest
     )}
  end

  def handle_event("update", %{"guest" => guest_params}, socket) do
    guest = socket.assigns.guest
    changeset = Guests.change_guest(guest, guest_params)

    if changeset.changes |> Map.keys() |> Enum.any?() do
      case Guests.update_guest(socket.assigns.guest, guest_params) do
        {:ok, guest} ->
          socket = put_flash(socket, :success, "#{guest.name} has been updated successfully")

          {:noreply, push_redirect(socket, to: "/guests")}

        {:error, _changeset} ->
          socket = put_flash(socket, :error, "Couldn't update guest")

          {:noreply, socket}
      end
    else
      socket = put_flash(socket, :info, "No changes detected")

      {:noreply, socket}
    end
  end

  def handle_event("validate", %{"guest" => guest_params}, socket) do
    changeset =
      %Guest{}
      |> Guests.change_guest(guest_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset))}
  end
end
