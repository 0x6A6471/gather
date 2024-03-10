[@react.component]
let make = (~open_, ~setOpen_) => {
  <div>
    <dialog open_ id="modal" className="bg-red-500 h-20">
      <div
        className="fixed inset-0 z-50 bg-black/50 data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0"
      />
      <div className="fixed inset-0 z-40" />
      <div
        className="fixed left-[50%] top-[50%] z-50 grid w-full max-w-lg translate-x-[-50%] translate-y-[-50%] gap-4 border border-gray-200 bg-white p-6 shadow-lg duration-200 data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[state=closed]:slide-out-to-left-1/2 data-[state=closed]:slide-out-to-top-[48%] data-[state=open]:slide-in-from-left-1/2 data-[state=open]:slide-in-from-top-[48%] sm:rounded-lg md:w-full">
        <button
          className="absolute top-4 right-4"
          onClick={_ => setOpen_(_ => false)}>
          {React.string("x")}
        </button>
        <h1 className="text-center text-xl font-semibold">
          {React.string("Modal Title")}
        </h1>
        <p className="text-center"> {React.string("Modal Description")} </p>
        <div className="mt-8">
          <label
            htmlFor="name"
            className="block text-sm font-medium leading-6 text-gray-900">
            {React.string("Name")}
          </label>
          <div className="mt-0.5">
            <input
              id="name"
              name="name"
              autoFocus=true
              required=true
              className="px-2 block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-200 placeholder:text-gray-400 focus:ring-inset focus:ring-gray-400 focus:outline-none sm:text-sm sm:leading-6"
              //onChange={e => {
              // let email = ReactEvent.Form.target(e)##value;
              // setEmail(_ => email);
              //}}
            />
          </div>
        </div>
      </div>
    </dialog>
  </div>;
};
