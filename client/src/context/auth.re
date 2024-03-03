type user = {
  id: int,
  email: string,
};

type t = {user: option(user)};

let init = {user: None};

let context = React.createContext(init);

module AuthContextProvider = {
  let makeProps = (~value, ~children, ()) => {
    "value": value,
    "children": children,
  };

  let make = React.Context.provider(context);
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
