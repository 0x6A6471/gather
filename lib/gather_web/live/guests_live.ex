defmodule GatherWeb.GuestsLive do
  use GatherWeb, :live_view

  alias Gather.Accounts
  alias Gather.Guests

  def render(assigns) do
    ~H"""
    <div class="max-w-screen-md mx-auto">
      <div class="flex items-center justify-between">
        <h1 class="font-bold text-3xl text-gray-50">Guests</h1>
        <div class="mt-4 sm:ml-16 sm:mt-0 sm:flex-none">
          <a
            href="/guests/new"
            class="block rounded-md bg-gather-500 px-3 py-2 text-center text-sm font-medium text-white hover:bg-gather-600"
          >
            Add guest
          </a>
        </div>
      </div>
      <div class="mt-8 flow-root">
        <div class="overflow-x-auto rounded-lg shadow ring-1 ring-black ring-opacity-5">
          <table class="min-w-full bg-gray-900 rounded-lg divide-y divide-gather-900">
            <thead class="bg-gray-900/80">
              <tr>
                <th
                  scope="col"
                  class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-100 sm:pl-6 whitespace-nowrap"
                >
                  Name
                </th>
                <th
                  scope="col"
                  class="px-3 py-3.5 text-left text-sm font-semibold text-gray-100 whitespace-nowrap"
                >
                  Address
                </th>
                <th
                  scope="col"
                  class="px-3 py-3.5 text-left text-sm font-semibold text-gray-100 whitespace-nowrap"
                >
                  Guest Amount
                </th>
                <th
                  scope="col"
                  class="px-3 py-3.5 text-left text-sm font-semibold text-gray-100 whitespace-nowrap"
                >
                  Save the Date
                </th>
                <th
                  scope="col"
                  class="px-3 py-3.5 text-left text-sm font-semibold text-gray-100 whitespace-nowrap"
                >
                  RSVP
                </th>
                <th
                  scope="col"
                  class="px-3 py-3.5 text-left text-sm font-semibold text-gray-100 whitespace-nowrap"
                >
                  Invite
                </th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gather-900 bg-gray-800/80">
              <tr :for={guest <- @guests}>
                <td class="whitespace-nowrap py-4 pl-4 pr-3 text-sm font-medium text-gray-100 sm:pl-6">
                  <%= guest.name %>
                </td>
                <td class="whitespace-nowrap px-3 py-4 text-sm">
                  <span class="block"><%= guest.address %></span>
                  <%= guest.city %>, <%= guest.state %>
                  <%= guest.zip %>
                </td>
                <td class="whitespace-nowrap px-3 py-4 text-sm">
                  <%= guest.guest_amount %>
                </td>
                <td class="whitespace-nowrap px-3 py-4 text-sm">
                  <%= guest.save_the_date_sent %>
                </td>
                <td class="whitespace-nowrap px-3 py-4 text-sm">
                  <%= guest.rsvp_sent %>
                </td>
                <td class="whitespace-nowrap px-3 py-4 text-sm">
                  <%= guest.invite_sent %>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, session, socket) do
    token = session["user_token"]
    user = Accounts.get_user_by_session_token(token)

    socket =
      assign(socket,
        guests: Guests.list_guests(user.id)
      )

    {:ok, socket}
  end
end
