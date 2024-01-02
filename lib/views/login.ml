let page req =
  let open Dream_html in
  let open HTML in
  html
    [ lang "en" ]
    [ head
        []
        [ title [] "Login"
        ; link [ rel "preconnect"; href "https://fonts.googleapis.com" ]
        ; link [ rel "preconnect"; href "https://fonts.gstatic.com" ]
        ; link
            [ rel "stylesheet"
            ; href
                "https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&display=swap"
            ]
        ; link [ rel "stylesheet"; href "/styles/output.css" ]
        ; script [ src "https://unpkg.com/htmx.org@1.9.10" ] ""
        ]
    ; body
        []
        [ h1 [ class_ "text-center text-4xl font-bold mb-8" ] [ txt "Login" ]
        ; form
            [ class_ "max-w-sm mx-auto"; method_ `POST; action "/login" ]
            [ csrf_tag req
            ; label
                [ class_ "text-xs font-bold"; for_ "email" ]
                [ txt "Email address" ]
            ; input
                [ name "email"
                ; id "email"
                ; class_ "block mt-1 border boder-gray-200 w-full rounded-lg"
                ]
            ; label
                [ class_ "text-xs font-bold"; for_ "password" ]
                [ txt "Password" ]
            ; input
                [ name "password"
                ; id "password"
                ; type_ "password"
                ; class_ "block mt-1 border boder-gray-200 w-full rounded-lg"
                ]
            ; input [ type_ "submit"; value "Login" ]
            ]
        ]
    ]
;;
