defmodule GatherWeb.DownloadController do
  use GatherWeb, :controller

  alias Gather.Guests

  def create(conn, %{"_action" => "download", "type" => type} = params) do
    user_id = conn.assigns.current_user.id
    guests = Guests.list_guests(user_id)

    case type do
      "csv" ->
        generate_and_download_csv(conn, params, "Generated successfully!", guests)

      "doc" ->
        generate_and_download_doc(conn, params, "Generated successfully!", guests)

      _ ->
        conn
        |> put_flash(:error, "Invalid download type.")
        |> redirect(to: "/guests")
        |> halt()
    end
  end

  defp generate_and_download_csv(conn, _params, _info, guests) do
    data =
      Enum.map(guests, fn guest ->
        %{
          "Name" => guest.name,
          "Address" => guest.address_line_1,
          "Address Line 2" => guest.address_line_2,
          "City" => guest.city,
          "State" => guest.state,
          "Zip" => guest.zip,
          "Guest Amount" => guest.guest_amount,
          "Save the Date Sent" => format_boolean(guest.save_the_date_sent),
          "RSVP Sent" => format_boolean(guest.rsvp_sent),
          "Invite Sent" => format_boolean(guest.invite_sent)
        }
      end)

    csv_content =
      data
      |> CSV.encode(
        headers: [
          "Name",
          "Address",
          "Address Line 2",
          "City",
          "State",
          "Zip",
          "Guest Amount",
          "Save the Date Sent",
          "RSVP Sent",
          "Invite Sent"
        ]
      )
      # Convert stream to string
      |> Enum.join()

    # Send csv content as downloadable file
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

  defp generate_and_download_doc(conn, _params, _info, guests) do
    doc_content =
      Enum.map(guests, fn guest ->
        """
        #{guest.name}
        #{guest.address_line_1}#{if guest.address_line_2, do: ", #{guest.address_line_2}"}
        #{guest.city}, #{guest.state} #{guest.zip}
        \n
        """
      end)
      |> Enum.join()

    conn
    |> put_resp_content_type("text")
    |> put_resp_header("content-disposition", "attachment; filename=\"guests.txt\"")
    |> send_resp(200, doc_content)
  end
end
