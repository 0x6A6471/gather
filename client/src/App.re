module App = {
  [@react.component]
  let make = () => {
    let url = ReasonReactRouter.useUrl();

    switch (url.path) {
    | [] => <Pages.HomePage />
    | ["login"] => <Pages.LoginPage />
    | _ => <h1> {React.string("404")} </h1>
    };
  };
};

ReactDOM.querySelector("#root")
->(
    fun
    | Some(root) => ReactDOM.render(<App />, root)
    | None =>
      Js.Console.error(
        "Failed to start React: couldn't find the #root element",
      )
  );
