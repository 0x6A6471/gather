defmodule GatherWeb.GuestsNewLive do
  use GatherWeb, :live_view

  alias Gather.Accounts

  def render(assigns) do
    ~H"""
    <div class="max-w-screen-md mx-auto bg-gray-900/80 rounded-lg p-8">
      <!-- figure out the action here-->
      <.simple_form
        for={@form}
        id="guest_form"
        action={~p"/guests?_action=guest_created"}
        phx-update="ignore"
      >
        <h1 class="text-3xl font-bold leading-7 text-center text-gray-100">Add Guest</h1>

        <input type="hidden" name="user_id" value={@user_id} />

        <div class="mt-10 grid grid-cols-1 gap-6 sm:grid-cols-6">
          <div class="sm:col-span-3">
            <.input field={@form[:name]} type="text" label="Name" required autofocus />
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
            <.input field={@form[:address]} type="text" label="Street address" required />
          </div>

          <div class="sm:col-span-2 sm:col-start-1">
            <.input field={@form[:city]} type="text" label="City" required />
          </div>

          <div class="sm:col-span-2">
            <.input field={@form[:state]} type="text" label="State" required />
          </div>

          <div class="sm:col-span-2">
            <.input field={@form[:zip]} type="text" label="Postal code" required />
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
              <.input field={@form[:rsvp_sent]} type="checkbox" label="Invite Sent" />
            </div>
          </div>
        </fieldset>

        <div class="mt-6 flex items-center justify-end gap-x-6">
          <a href="/guests" class="text-sm font-medium leading-6 text-gray-100">Cancel</a>
          <button
            type="submit"
            class="block rounded-md bg-gather-500 px-3 py-2 text-center text-sm font-medium text-white hover:bg-gather-600"
          >
            Save
          </button>
        </div>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, session, socket) do
    email = live_flash(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "guest")
    token = session["user_token"]
    user = Accounts.get_user_by_session_token(token)
    user_id = user.id

    {:ok, assign(socket, form: form, user_id: user_id), temporary_assigns: [form: form]}
  end
end
