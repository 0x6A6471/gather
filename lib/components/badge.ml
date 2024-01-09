let badge check =
  let open Dream_html in
  let open HTML in
  let text = if check then "Yes" else "No" in
  let colors =
    if check
    then "bg-emerald-50 text-emerald-700 ring-emerald-600/10"
    else "bg-rose-50 text-rose-700 ring-rose-600/10"
  in
  let class_string =
    "inline-flex items-center rounded-md  px-2 py-1 text-xs font-medium ring-1 \
     ring-inset "
    ^ colors
  in
  span [ class_ "%s" class_string ] [ txt "%s" text ]
;;
