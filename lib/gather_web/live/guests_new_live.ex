defmodule GatherWeb.GuestsNewLive do
  use GatherWeb, :live_view

  alias Gather.Accounts
  alias Gather.Guests
  alias Gather.Guests.Guest

  def render(assigns) do
    ~H"""
    <div class="max-w-screen-md mx-auto bg-gray-900/80 rounded-lg p-8">
      <.form
        for={@form}
        id="guest_form"
        action={~p"/guests?_action=guest_created"}
        phx-change="validate"
      >
        <h1 class="text-3xl font-bold leading-7 text-center text-gray-100">Add Guest</h1>

        <input type="hidden" name="user_id" value={@user_id} />

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
              value="1"
              min="1"
              type="number"
              label="Guest amount"
              required
              autofocus
            />
          </div>

          <div class="sm:col-span-4">
            <.input
              field={@form[:address]}
              type="text"
              label="Street address"
              placeholder="123 Main St."
              required
            />
          </div>

          <div class="sm:col-span-2 sm:col-start-1">
            <.input field={@form[:city]} type="text" label="City" placeholder="Boston" required />
          </div>
          <!-- TODO: make this a select -->
          <div class="sm:col-span-2">
            <.input field={@form[:state]} type="text" label="State" placeholder="MA" required />
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

  def mount(_params, session, socket) do
    changeset = Guests.change_guest(%Guest{})

    token = session["user_token"]
    user = Accounts.get_user_by_session_token(token)
    user_id = user.id

    {:ok, assign(socket, form: to_form(changeset), user_id: user_id)}
  end

  def handle_event("validate", %{"guest" => guest_params}, socket) do
    changeset =
      %Guest{}
      |> Guests.change_guest(guest_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset))}
  end
end
