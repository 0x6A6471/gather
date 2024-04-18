defmodule GatherWeb.CsvController do
  use GatherWeb, :controller

  alias Gather.Guests

  def create(conn, %{"_action" => "csv_download"} = params) do
    conn
    |> put_session(:user_return_to, ~p"/guests")
    |> generate_and_download_csv(params, "Guest added successfully!")
  end

  defp generate_and_download_csv(conn, _params, _info) do
    user_id = conn.assigns.current_user.id

    guests = Guests.list_guests(user_id)

    data =
      Enum.map(guests, fn guest ->
        %{
          "Name" => guest.name,
          "Address" => guest.address,
          "City" => guest.city,
          "State" => guest.state,
          "Zip" => guest.zip,
          "Guest Amount" => guest.guest_amount,
          "Save the Date Sent" => format_boolean(guest.save_the_date_sent),
          "RSVP Sent" => format_boolean(guest.rsvp_sent),
          "Invite Sent" => format_boolean(guest.invite_sent)
        }
      end)

    # Encode the data with specified headers
    csv_content =
      data
      |> CSV.encode(
        headers: [
          "Name",
          "Address",
          "City",
          "State",
          "Zip",
          "Guest Amount",
          "Save the Date Sent",
          "RSVP Sent",
          "Invite Sent"
        ]
      )
      # Convert the stream into a single string
      |> Enum.join()

    # Send the CSV content as a downloadable file
    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=\"guests.csv\"")
    |> send_resp(200, csv_content)
  end

  defp format_boolean(value) do
    if value do
      "Yes"
    else
      "No"
    end
  end
end
