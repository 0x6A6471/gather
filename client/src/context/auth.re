type user = {
  id: int,
  email: string,
};

type t = {
  user: option(user),
  login: (string, string) => unit,
};

let init = {user: None, login: (_email, _password) => ()};

let context = React.createContext(init);

module Decode = {
  let user = json =>
    Json.Decode.{
      id: json |> field("id", int),
      email: json |> field("email", string),
    };
};

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
    let (user, setUser) = React.useState(() => None);

    let login = (email: string, password: string) => {
      let payload = Js.Dict.empty();
      Js.Dict.set(payload, "email", Js.Json.string(email));
      Js.Dict.set(payload, "password", Js.Json.string(password));
      Js.Promise.(
        Fetch.fetchWithInit(
          "http://localhost:8080/login",
          Fetch.RequestInit.make(
            ~method_=Post,
            ~body=
              Fetch.BodyInit.make(
                Js.Json.stringify(Js.Json.object_(payload)),
              ),
            ~headers=
              Fetch.HeadersInit.make({"Content-Type": "application/json"}),
            (),
          ),
        )
        |> then_(Fetch.Response.json)
        |> then_(json => {
             Js.log(json);
             let user = json |> Decode.user;
             setUser(_ => Some(user));
             ReasonReactRouter.push("/");
             resolve();
           })
        |> catch(error => {
             Js.log(error);
             setUser(_ => None);
             resolve();
           })
      )
      |> ignore;
    };

    let value = {user, login};

    <AuthContextProvider value> children </AuthContextProvider>;
  };
};

let useAuth = () => React.useContext(context);
