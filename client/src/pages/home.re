[@react.component]
let make = () => {
  let auth = Context.AuthContext.useAuth();

  React.useEffect1(
    () => {
      switch (auth.user) {
      | None =>
        ReasonReactRouter.push("/login");
        None;
      | Some(_) => None
      }
    },
    [|auth.user|],
  );

  switch (auth.user) {
  | Some(user) => <h1> {React.string("Hi, " ++ user.email)} </h1>
  | None => React.null
  };
};

