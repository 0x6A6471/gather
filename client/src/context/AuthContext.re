type user = {
  id: int,
  email: string,
};

type authContext = {user: option(user)};

let initContext = {user: None};

let authContext = React.createContext(initContext);

module AuthContextProvider = {
  let makeProps = (~value, ~children, ()) => {
    "value": value,
    "children": children,
  };

  let make = React.Context.provider(authContext);
};

module AuthProvider = {
  [@react.component]
  let make = (~children) => {
    let (user, _) =
      React.useState(() => Some({id: 1, email: "hi@gmail.com"}));

    let value = {user: user};

    <AuthContextProvider value> children </AuthContextProvider>;
  };
};
