[@react.component]
let make = () => {
  let auth = Context.AuthContext.useAuth();

  let userExists = auth.user |> Belt.Option.isSome;

  React.useEffect1(
    () => {
      if (!auth.loading) {
        switch (auth.user) {
        | None => ReasonReactRouter.push("/login")
        | Some(_) => ()
        };
      };
      None;
    },
    [|auth.loading, userExists|],
  );

  if (auth.loading) {
    <div> {React.string("Loading...")} </div>;
  } else {
    switch (auth.user) {
    | Some(user) =>
      <div>
        <img src="/test.jpg" alt="test" />
        <Components.Ui.Link to_="/login">
          {React.string("Go to login, " ++ user.email)}
        </Components.Ui.Link>
        <button onClick={_ => auth.logout()}>
          {React.string("Logout")}
        </button>
        <Components.GuestsTable />
      </div>
    | None => React.null
    };
  };
};
