[@react.component]
let make = () => {
  let auth = Context.AuthContext.useAuth();

  switch (auth.user) {
  | None => <h1> {React.string("Please login")} </h1>
  | Some(user) => <h1> {React.string("Hi, " ++ user.email)} </h1>
  };
};
