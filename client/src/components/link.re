[@react.component]
let make = (~to_, ~children) => {
  let navigate = _event => {
    _event->ReactEvent.Synthetic.preventDefault;
    ReasonReactRouter.push(to_);
  };

  <a href=to_ onClick=navigate> children </a>;
};
