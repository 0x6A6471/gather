[@react.component]
let make = (~label, ~color) => {
  let color =
    switch (color) {
    | `Green => "bg-emerald-50 text-emerald-600 ring-emerald-500/10"
    | `Red => "bg-rose-50 text-rose-600 ring-rose-500/10"
    };

  let baseClass = "inline-flex items-center rounded-md  px-2 py-1 text-xs font-medium ring-1 ring-inset";
  let classes = baseClass ++ " " ++ color;

  <span className=classes> {React.string(label)} </span>;
};
