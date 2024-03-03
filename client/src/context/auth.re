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
    let (user, _) = React.useState(() => None);

    let login = (email: string, password: string) => {
      let payload = Js.Dict.empty();
      Js.Dict.set(payload, "email", Js.Json.string(email));
      Js.Dict.set(payload, "password", Js.Json.string(password));
      Js.Promise.(
        Fetch.fetchWithInit(
          "http://localhost:8080/api/login",
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
             resolve();
           })
        |> catch(err => {
             Js.log2("Error:", err);
             resolve();
           })
      )
      |> ignore;
    };

    let value = {user, login};

    <AuthContextProvider value> children </AuthContextProvider>;
  };
};
