[@react.component]
let make = () => {
  let auth = Context.AuthContext.useAuth();
  let (email, setEmail) = React.useState(() => "");
  let (password, setPassword) = React.useState(() => "");

  let handleSubmit = e => {
    ReactEvent.Form.preventDefault(e);
    auth.login(email, password);
  };

  <div className="h-screen flex flex-col items-center justify-center">
    <h1 className="text-2xl font-semibold">
      {React.string("Sign In to Registry")}
    </h1>
    <form className="mt-8 min-w-72" onSubmit=handleSubmit>
      <div>
        <label
          htmlFor="email"
          className="block text-sm font-medium leading-6 text-gray-900">
          {React.string("Email")}
        </label>
        <div className="mt-0.5">
          <input
            id="email"
            name="email"
            autoFocus=true
            required=true
            className="px-2 block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-200 placeholder:text-gray-400 focus:ring-inset focus:ring-gray-400 focus:outline-none sm:text-sm sm:leading-6"
            onChange={e => {
              let email = ReactEvent.Form.target(e)##value;
              setEmail(_ => email);
            }}
          />
        </div>
        <div className="mt-4">
          <label
            htmlFor="password"
            value=email
            className="block text-sm font-medium leading-6 text-gray-900"
            onChange={e => {
              let e = ReactEvent.Form.target(e)##value;
              setEmail(_ => e);
            }}>
            {React.string("Pasword")}
          </label>
          <div className="mt-0.5">
            <input
              type_="password"
              id="password"
              name="password"
              value=password
              required=true
              className="px-2 block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-200 placeholder:text-gray-400 focus:ring-inset focus:ring-gray-400 focus:outline-none sm:text-sm sm:leading-6"
              onChange={e => {
                let password = ReactEvent.Form.target(e)##value;
                setPassword(_ => password);
              }}
            />
          </div>
        </div>
      </div>
      <button
        type_="submit"
        className="mt-8 flex w-full justify-center rounded-md bg-black px-3 py-1.5 text-sm font-medium leading-6 text-white shadow-sm hover:bg-black/80">
        {React.string("Sign In")}
      </button>
    </form>
  </div>;
};
