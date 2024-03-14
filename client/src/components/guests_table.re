open Radix;

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

  let addGuest = () => {
    let payload = Js.Dict.empty();
    Js.Dict.set(payload, "name", Js.Json.string("Hiiiiiiiiiiii"));
    Js.Dict.set(payload, "address", Js.Json.string("1234 Main St"));
    Js.Dict.set(payload, "city", Js.Json.string("San Francisco"));
    Js.Dict.set(payload, "state", Js.Json.string("CA"));
    Js.Dict.set(payload, "zip", Js.Json.string("94123"));
    Js.Dict.set(payload, "guest_amount", Js.Json.number(2.));
    Js.Dict.set(payload, "rsvp_sent", Js.Json.number(0.));
    Js.Dict.set(payload, "invite_sent", Js.Json.number(0.));
    Js.Dict.set(payload, "save_the_date_sent", Js.Json.number(0.));

    Js.Promise.(
      Fetch.fetchWithInit(
        "http://localhost:8080/guests",
        Fetch.RequestInit.make(
          ~method_=Post,
          ~body=
            Fetch.BodyInit.make(
              Js.Json.stringify(Js.Json.object_(payload)),
            ),
          ~credentials=Include,
          ~headers=
            Fetch.HeadersInit.make({"Content-Type": "application/json"}),
          (),
        ),
      )
      |> then_(Fetch.Response.json)
      |> then_(json => {
           getGuests();
           Js.log(json);
           resolve();
         })
      |> catch(error => {
           Js.log2("Error in addGuest:", error);
           resolve();
         })
    )
    |> ignore;
  };

  <>
    <button onClick={_ => addGuest()}> {React.string("Add guest?")} </button>
    <Dialog.root>
      <Dialog.trigger
        className="rounded-md bg-gray-900 px-2.5 py-1.5 text-sm font-medium text-white shadow-sm hover:bg-gray-800 float-right">
        {React.string("Add Guest")}
      </Dialog.trigger>
      <Dialog.portal>
        <Dialog.overlay
          className="fixed inset-0 z-50 bg-black/50 data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0"
        />
        <Dialog.content
          className="fixed left-[50%] top-[50%] z-50 grid w-full max-w-lg translate-x-[-50%] translate-y-[-50%] gap-4 bg-white p-6 shadow-lg duration-200 data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[state=closed]:slide-out-to-left-1/2 data-[state=closed]:slide-out-to-top-[48%] data-[state=open]:slide-in-from-left-1/2 data-[state=open]:slide-in-from-top-[48%] rounded-lg md:w-full">
          <p> {React.string("CONTENTTTTTTTTTTTTTTTTTT")} </p>
          <Dialog.close className="absolute top-4 right-4 bg-red-500">
            {React.string("Close")}
          </Dialog.close>
        </Dialog.content>
      </Dialog.portal>
    </Dialog.root>
    <div className="px-4">
      <div className="mt-4 flow-root">
        <div className="-mx-4 -my-2 overflow-x-auto">
          <div className="inline-block min-w-full py-2 align-middle">
            <div
              className="overflow-hidden shadow ring-1 ring-black ring-opacity-5 sm:rounded-lg">
              <table className="min-w-full divide-y divide-gray-300">
                <thead className="bg-gray-50">
                  <tr>
                    <th
                      scope="col"
                      className="py-3.5 px-4 text-left text-sm font-medium text-gray-900 whitespace-nowrap">
                      {React.string("Name")}
                    </th>
                    <th
                      scope="col"
                      className="py-3.5 px-4 text-left text-sm font-medium text-gray-900 whitespace-nowrap">
                      {React.string("Address")}
                    </th>
                    <th
                      scope="col"
                      className="py-3.5 px-4 text-left text-sm font-medium text-gray-900 whitespace-nowrap">
                      {React.string("# of Guests")}
                    </th>
                    <th
                      scope="col"
                      className="py-3.5 px-4 text-left text-sm font-medium text-gray-900 whitespace-nowrap">
                      {React.string("RSVP Sent")}
                    </th>
                    <th
                      scope="col"
                      className="py-3.5 px-4 text-left text-sm font-medium text-gray-900 whitespace-nowrap">
                      {React.string("Invite Sent")}
                    </th>
                    <th
                      scope="col"
                      className="py-3.5 px-4 text-left text-sm font-medium text-gray-900 whitespace-nowrap">
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
  </>;
};
