open Radix;

type t = {
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

[@react.component]
let make = () => {
  let (guest, setGuest) =
    React.useState(_ =>
      {
        name: "",
        address: "",
        city: "",
        state: "",
        zip: "",
        guest_amount: 0,
        rsvp_sent: 0,
        invite_sent: 0,
        save_the_date_sent: 0,
      }
    );

  let handleSubmit = e => {
    ReactEvent.Form.preventDefault(e);
    Js.log(guest);

    let payload = Js.Dict.empty();
    Js.Dict.set(payload, "name", Js.Json.string(guest.name));
    Js.Dict.set(payload, "address", Js.Json.string(guest.address));
    Js.Dict.set(payload, "city", Js.Json.string(guest.city));
    Js.Dict.set(payload, "state", Js.Json.string(guest.state));
    Js.Dict.set(payload, "zip", Js.Json.string(guest.zip));
    Js.Dict.set(
      payload,
      "guest_amount",
      Js.Json.number(float_of_int(guest.guest_amount)),
    );
    Js.Dict.set(
      payload,
      "rsvp_sent",
      Js.Json.number(float_of_int(guest.rsvp_sent)),
    );
    Js.Dict.set(
      payload,
      "invite_sent",
      Js.Json.number(float_of_int(guest.invite_sent)),
    );
    Js.Dict.set(
      payload,
      "save_the_date_sent",
      Js.Json.number(float_of_int(guest.save_the_date_sent)),
    );

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
           //  getGuests();
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
        <Dialog.title
          className="text-2xl font-semibold text-gray-900 text-center">
          {React.string("Add Guest")}
        </Dialog.title>
        <form onSubmit=handleSubmit>
          <div>
            <label
              htmlFor="name"
              className="block text-sm font-medium leading-6 text-gray-900">
              {React.string("Name")}
            </label>
            <div className="mt-0.5">
              <input
                name="name"
                id="name"
                className="block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
                placeholder="Jane Doe"
                required=true
                onChange={e => {
                  let name = ReactEvent.Form.target(e)##value;
                  setGuest(guest => {...guest, name});
                }}
              />
            </div>
          </div>
          <div>
            <label
              htmlFor="address"
              className="block text-sm font-medium leading-6 text-gray-900">
              {React.string("Address")}
            </label>
            <div className="mt-0.5">
              <input
                name="address"
                id="address"
                className="block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
                placeholder="123 Main St"
                required=true
                onChange={e => {
                  let address = ReactEvent.Form.target(e)##value;
                  setGuest(guest => {...guest, address});
                }}
              />
            </div>
          </div>
          <div>
            <label
              htmlFor="city"
              className="block text-sm font-medium leading-6 text-gray-900">
              {React.string("City")}
            </label>
            <div className="mt-0.5">
              <input
                name="city"
                id="city"
                className="block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
                placeholder="Appleton"
                required=true
                onChange={e => {
                  let city = ReactEvent.Form.target(e)##value;
                  setGuest(guest => {...guest, city});
                }}
              />
            </div>
          </div>
          <div>
            <label
              htmlFor="state"
              className="block text-sm font-medium leading-6 text-gray-900">
              {React.string("State")}
            </label>
            <div className="mt-0.5">
              <input
                name="state"
                id="state"
                className="block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
                placeholder="WI"
                required=true
                onChange={e => {
                  let city = ReactEvent.Form.target(e)##value;
                  setGuest(guest => {...guest, city});
                }}
              />
            </div>
          </div>
          <div>
            <label
              htmlFor="zip"
              className="block text-sm font-medium leading-6 text-gray-900">
              {React.string("Zip")}
            </label>
            <div className="mt-0.5">
              <input
                name="zup"
                id="zup"
                className="block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
                placeholder="54911"
                required=true
                onChange={e => {
                  let zip = ReactEvent.Form.target(e)##value;
                  setGuest(guest => {...guest, zip});
                }}
              />
            </div>
          </div>
          <div className="flex items-center">
            <div className="flex h-6 items-center">
              <input
                id="rsvp"
                name="rsvp"
                type_="checkbox"
                className="h-4 w-4 rounded border-gray-300 text-indigo-600 focus:ring-indigo-600"
              />
            </div>
            <div className="ml-3 text-sm leading-6">
              <label htmlFor="comments" className="font-medium text-gray-900">
                {React.string("RSVP")}
              </label>
            </div>
          </div>
          <button
            type_="submit"
            className="mt-8 flex w-full justify-center rounded-md bg-black px-3 py-1.5 text-sm font-medium leading-6 text-white shadow-sm hover:bg-black/80">
            {React.string("Add Guest")}
          </button>
        </form>
        <Dialog.close
          className="absolute top-2 right-2 h-6 w-6 text-gray-500 hover:bg-gray-100 hover:text-gray-700 p-1 rounded">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256">
            <rect width="256" height="256" fill="none" />
            <line
              x1="200"
              y1="56"
              x2="56"
              y2="200"
              stroke="currentColor"
              strokeLinecap="round"
              strokeLinejoin="round"
              strokeWidth="16"
            />
            <line
              x1="200"
              y1="200"
              x2="56"
              y2="56"
              stroke="currentColor"
              strokeLinecap="round"
              strokeLinejoin="round"
              strokeWidth="16"
            />
          </svg>
        </Dialog.close>
      </Dialog.content>
    </Dialog.portal>
  </Dialog.root>;
};
