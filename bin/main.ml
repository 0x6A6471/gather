let page _ =
  let open Dream_html in
  let open HTML in
  html
    [ lang "en" ]
    [ head
        []
        [ title [] "Jake & Jen Guest List"
        ; link [ rel "preconnect"; href "https://fonts.googleapis.com" ]
        ; link [ rel "preconnect"; href "https://fonts.gstatic.com" ]
        ; link
            [ rel "stylesheet"
            ; href
                "https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&display=swap"
            ]
        ; link [ rel "stylesheet"; href "/static/global.css" ]
        ; script [ src "https://unpkg.com/htmx.org@1.9.10" ] ""
        ]
    ; body
        []
        [ h1 [] [ txt "Jake & Jen Wedding Guest List" ]
        ; div
            []
            [ button
                [ Hx.post "/server"; Hx.target "#response" ]
                [ txt "Get HTML from server" ]
            ; div [ id "response" ] []
            ]
        ]
    ]
;;

(* Integrated with Dream response *)
let handler req = Dream_html.respond (page req)

let test_html _ =
  let open Dream_html in
  let open HTML in
  html [ lang "en" ] [ p [ style_ "color: red;" ] [ txt "Hi from server" ] ]
;;

let handler_test req = Dream_html.respond (test_html req)

let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.router
       [ Dream.get "/" handler
       ; Dream.post "/server" handler_test
       ; Dream.get "/echo/:word" (fun request ->
           Dream.html (Dream.param request "word"))
       ; Dream.get "/static/**" (Dream.static ".")
       ]
;;
