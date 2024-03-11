type t = {
  id: int,
  name: string,
  address: string,
  city: string,
  state: string,
  zip: string,
  guest_amount: int,
  rsvp_sent: int,
  invite_sent: int,
  save_the_date_sent: int,
};

module Decode = {
  let guest = json =>
    Json.Decode.{
      id: json |> field("id", int),
      name: json |> field("name", string),
      address: json |> field("address", string),
      city: json |> field("city", string),
      state: json |> field("state", string),
      zip: json |> field("zip", string),
      guest_amount: json |> field("guest_amount", int),
      rsvp_sent: json |> field("rsvp_sent", int),
      invite_sent: json |> field("invite_sent", int),
      save_the_date_sent: json |> field("save_the_date_sent", int),
    };
};

[@react.component]
let make = () => {
  let (modalOpen, setModalOpen) = React.useState(_ => false);
  let (guests, setGuests) = React.useState(_ => []);

  let getGuests = () => {
    Js.Promise.(
      Fetch.fetchWithInit(
        "http://localhost:8080/guests",
        Fetch.RequestInit.make(
          ~credentials=Include,
          ~headers=
            Fetch.HeadersInit.make({"Content-Type": "application/json"}),
          (),
        ),
      )
      |> then_(Fetch.Response.json)
      |> then_(json => {
           let guests = json |> Json.Decode.list(Decode.guest);
           setGuests(_ => guests);
           resolve();
         })
      |> catch(error => {
           Js.log2("error", error);
           resolve();
         })
    )
    |> ignore;
  };

  React.useEffect0(() => {
    getGuests();
    None;
  });

  <div>
    <Ui.Modal open_=modalOpen setOpen_=setModalOpen />
    <div className="px-4 sm:px-6 lg:px-8">
      <div className="mt-8 flow-root">
        <div className="-mx-4 -my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
          <button
            className="rounded-md bg-gray-900 px-2.5 py-1.5 text-sm font-medium text-white shadow-sm hover:bg-gray-800 float-right mr-8"
            onClick={_ => setModalOpen(_ => !modalOpen)}>
            {React.string("Add Guest")}
          </button>
          <div
            className="inline-block min-w-full py-2 align-middle sm:px-6 lg:px-8">
            <div
              className="overflow-hidden shadow ring-1 ring-black ring-opacity-5 sm:rounded-lg">
              <table className="min-w-full divide-y divide-gray-300">
                <thead className="bg-gray-50">
                  <tr>
                    <th
                      scope="col"
                      className="py-3.5 px-4 text-left text-sm font-medium text-gray-900">
                      {React.string("Name")}
                    </th>
                    <th
                      scope="col"
                      className="py-3.5 px-4 text-left text-sm font-medium text-gray-900">
                      {React.string("Address")}
                    </th>
                    <th
                      scope="col"
                      className="py-3.5 px-4 text-left text-sm font-medium text-gray-900">
                      {React.string("# of Guests")}
                    </th>
                    <th
                      scope="col"
                      className="py-3.5 px-4 text-left text-sm font-medium text-gray-900">
                      {React.string("RSVP Sent")}
                    </th>
                    <th
                      scope="col"
                      className="py-3.5 px-4 text-left text-sm font-medium text-gray-900">
                      {React.string("Invite Sent")}
                    </th>
                    <th
                      scope="col"
                      className="py-3.5 px-4 text-left text-sm font-medium text-gray-900">
                      {React.string("STD Sent")}
                    </th>
                    <th scope="col" className="relative py-3.5 px-4">
                      <span className="sr-only">
                        {React.string("Actions")}
                      </span>
                    </th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-200 bg-white">
                  {guests
                   |> List.map(guest =>
                        <tr key={string_of_int(guest.id)}>
                          <td
                            className="whitespace-nowrap p-4 text-sm font-medium text-gray-900">
                            {React.string(guest.name)}
                          </td>
                          <td
                            className="whitespace-nowrap p-4 text-sm text-gray-500">
                            {React.string(guest.address)}
                            {React.string(", ")}
                            {React.string(guest.city)}
                            {React.string(", ")}
                            {React.string(guest.state)}
                            {React.string(" ")}
                            {React.string(guest.zip)}
                          </td>
                          <td
                            className="whitespace-nowrap p-4 text-sm font-medium text-gray-500">
                            {React.string(string_of_int(guest.guest_amount))}
                          </td>
                          <td className="whitespace-nowrap p-4">
                            <Ui.Badge
                              label={guest.rsvp_sent === 1 ? "Yes" : "No"}
                              color={guest.rsvp_sent === 1 ? `Green : `Red}
                            />
                          </td>
                          <td className="whitespace-nowrap p-4">
                            <Ui.Badge
                              label={guest.invite_sent === 1 ? "Yes" : "No"}
                              color={guest.invite_sent === 1 ? `Green : `Red}
                            />
                          </td>
                          <td className="whitespace-nowrap p-4">
                            <Ui.Badge
                              label={
                                guest.save_the_date_sent === 1 ? "Yes" : "No"
                              }
                              color={
                                guest.save_the_date_sent === 1 ? `Green : `Red
                              }
                            />
                          </td>
                          <td
                            className="whitespace-nowrap p-4 text-sm text-gray-500">
                            <a
                              href="#"
                              className="text-blue-500 hover:text-blue-700">
                              {React.string("Actions")}
                            </a>
                          </td>
                        </tr>
                      )
                   |> Array.of_list
                   |> React.array}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>;
};
