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

let page guests =
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
        ; link [ rel "stylesheet"; href "/styles/output.css" ]
        ; script [ src "https://unpkg.com/htmx.org@1.9.10" ] ""
        ]
    ; body
        []
        [ div
            [ class_ "px-4" ]
            [ h1
                [ class_ "text-center text-4xl font-bold" ]
                [ txt "Jake & Jen Wedding Guest List" ]
            ; div
                [ class_ "mt-8" ]
                [ div
                    [ class_ "-mx-4 -my-2 overflow-x-auto p-1" ]
                    [ div
                        [ class_ "inline-block min-w-full py-2 align-middle" ]
                        [ div
                            [ class_
                                "overflow-hidden shadow ring-1 ring-black \
                                 ring-opacity-5 rounded-lg"
                            ]
                            [ table
                                [ class_ "min-w-full divide-y divide-gray-200" ]
                                [ thead
                                    [ class_ "bg-gray-50" ]
                                    [ tr
                                        []
                                        [ th
                                            [ class_
                                                "py-3.5 pl-4 pr-3 text-left \
                                                 text-sm font-semibold \
                                                 text-gray-900"
                                            ]
                                            [ txt "Name" ]
                                        ; th
                                            [ class_
                                                "py-3.5 pl-4 pr-3 text-left \
                                                 text-sm font-semibold \
                                                 text-gray-900"
                                            ]
                                            [ txt "Address" ]
                                        ; th
                                            [ class_
                                                "py-3.5 pl-4 pr-3 text-left \
                                                 text-sm font-semibold \
                                                 text-gray-900"
                                            ]
                                            [ txt "Amount" ]
                                        ; th
                                            [ class_
                                                "py-3.5 pl-4 pr-3 text-left \
                                                 text-sm font-semibold \
                                                 text-gray-900"
                                            ]
                                            [ txt "RSVP" ]
                                        ; th
                                            [ class_
                                                "py-3.5 pl-4 pr-3 text-left \
                                                 text-sm font-semibold \
                                                 text-gray-900"
                                            ]
                                            [ txt "Invite" ]
                                        ; th
                                            [ class_
                                                "py-3.5 pl-4 pr-3 text-left \
                                                 text-sm font-semibold \
                                                 text-gray-900"
                                            ]
                                            [ txt "Save the Date" ]
                                        ; th
                                            [ class_
                                                "py-3.5 pl-4 pr-3 text-left \
                                                 text-sm font-semibold \
                                                 text-gray-900"
                                            ]
                                            [ txt "Edit" ]
                                        ]
                                    ]
                                ; tbody
                                    [ Hx.target "closest tr"
                                    ; Hx.swap "outerHTML"
                                    ; class_ "divide-y divide-gray-200 bg-white"
                                    ]
                                    (List.map
                                       (fun ( id
                                            , name
                                            , address
                                            , amount
                                            , rsvp
                                            , invite_sent
                                            , save_the_date ) ->
                                         tr
                                           []
                                           [ td
                                               [ class_
                                                   "whitespace-nowrap px-3 \
                                                    py-4 text-sm text-gray-900 \
                                                    font-bold"
                                               ]
                                               [ txt "%s" name ]
                                           ; td
                                               [ class_
                                                   "whitespace-nowrap px-3 \
                                                    py-4 text-sm text-gray-500"
                                               ]
                                               [ txt "%s" address ]
                                           ; td
                                               [ class_
                                                   "whitespace-nowrap px-3 \
                                                    py-4 text-sm text-gray-500"
                                               ]
                                               [ txt "%d" amount ]
                                           ; td
                                               [ class_
                                                   "whitespace-nowrap px-3 py-4"
                                               ]
                                               [ badge rsvp ]
                                           ; td
                                               [ class_
                                                   "whitespace-nowrap px-3 py-4"
                                               ]
                                               [ badge invite_sent ]
                                           ; td
                                               [ class_
                                                   "whitespace-nowrap px-3 py-4"
                                               ]
                                               [ badge save_the_date ]
                                           ; td
                                               [ class_
                                                   "whitespace-nowrap px-3 \
                                                    py-4 text-sm text-gray-500"
                                               ]
                                               [ button
                                                   [ Hx.get "/guests/%i/edit" id
                                                   ; class_
                                                       "rounded bg-indigo-600 \
                                                        px-2 py-1 text-xs \
                                                        font-semibold \
                                                        text-white shadow-sm \
                                                        hover:bg-indigo-500 \
                                                        focus-visible:outline \
                                                        focus-visible:outline-2 \
                                                        focus-visible:outline-offset-2 \
                                                        focus-visible:outline-indigo-600"
                                                   ]
                                                   [ txt "Edit" ]
                                               ]
                                           ])
                                       guests)
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ]
;;
