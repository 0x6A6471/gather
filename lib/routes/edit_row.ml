let checkbox cond =
  let open Dream_html in
  let open HTML in
  if cond
  then input [ type_ "checkbox"; checked ]
  else input [ type_ "checkbox" ]
;;

let row _ =
  let open Dream_html in
  let open HTML in
  tr
    []
    [ td
        [ class_ "whitespace-nowrap px-3 py-4 text-sm text-gray-900 font-bold" ]
        [ txt "Dummy Name" ]
    ; td
        [ class_ "whitespace-nowrap px-3 py-4 text-sm text-gray-500" ]
        [ txt "Dummy Address" ]
    ; td [] [ button [] [ txt "hi" ] ]
    ]
;;

let handler_test req =
  Dream.log "Received request for /guests/:id/edit";
  (* Log the request path *)
  let response_content = row req in
  (* Optional: Log the generated HTML content *)
  Dream.log "Response HTML: %s" (Dream_html.to_string response_content);
  Dream_html.respond
    ~status:`OK
    ~headers:[ "Content-Type", "text/html" ]
    response_content
;;

let edit_row_routes _ =
  [ Dream.get "/guests/:id/edit" (fun req -> handler_test req) ]
;;
