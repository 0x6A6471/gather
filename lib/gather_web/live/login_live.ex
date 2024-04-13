defmodule GatherWeb.UserLoginLive do
  use GatherWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="flex h-screen flex-col justify-center px-4">
      <img class="mx-auto h-20 rounded-full w-auto" src="/images/gather.webp" alt="Gather" />
      <h2 class="mt-6 text-center text-2xl font-bold leading-9 tracking-tight text-gray-100">
        Sign in to Gather
      </h2>

      <div class="mt-10 sm:mx-auto sm:w-full sm:max-w-[480px]">
        <div class="bg-gray-900 px-6 py-12 sm:rounded-lg sm:px-12">
          <.simple_form for={@form} id="login_form" action={~p"/login"} phx-update="ignore">
            <.input field={@form[:email]} type="email" label="Email" required autofocus />
            <.input field={@form[:password]} type="password" label="Password" required />

            <:actions>
              <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" />
              <.link href={~p"/users/reset_password"} class="text-sm font-semibold">
                Forgot your password?
              </.link>
            </:actions>
            <:actions>
              <.button phx-disable-with="Signing in..." class="w-full">
                Sign in <span aria-hidden="true">→</span>
              </.button>
            </:actions>
          </.simple_form>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = live_flash(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
