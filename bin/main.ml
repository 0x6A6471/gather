open Lwt.Syntax

module type DB = Caqti_lwt.CONNECTION

module T = Caqti_type

let init_pool () =
  let uri = Uri.make ~scheme:"sqlite3" ~path:"./registry.db" () in
  match Caqti_lwt.connect_pool ~max_size:10 uri with
  | Ok pool -> pool
  | Error err -> failwith (Caqti_error.show err)
;;

let pool = init_pool ()

let get_guests pool user_id =
  let query =
    [%rapper
      get_many
        {sql| SELECT @string{name}, @string{address}, @int{amount}, @bool{rsvp}, @bool{invite_sent}, @bool{save_the_date} FROM guests WHERE user_id = %int{user_id} |sql}]
  in
  (* let* guests_result = Caqti_lwt.Pool.use (fun db -> db query ~user_id) pool in *)
  let* result = Caqti_lwt.Pool.use (fun db -> query db ~user_id) pool in
  match result with
  | Error e -> failwith (Caqti_error.show e)
  | Ok guests -> Lwt.return guests
;;

let checkbox cond =
  let open Dream_html in
  let open HTML in
  if cond
  then input [ type_ "checkbox"; checked ]
  else input [ type_ "checkbox" ]
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
                                        ]
                                    ]
                                ; tbody
                                    [ class_ "divide-y divide-gray-200 bg-white"
                                    ]
                                    (List.map
                                       (fun ( name
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
                                                   "whitespace-nowrap px-3 \
                                                    py-4 text-sm text-gray-500"
                                               ]
                                               [ checkbox rsvp ]
                                           ; td
                                               [ class_
                                                   "whitespace-nowrap px-3 \
                                                    py-4 text-sm text-gray-500"
                                               ]
                                               [ checkbox invite_sent ]
                                           ; td
                                               [ class_
                                                   "whitespace-nowrap px-3 \
                                                    py-4 text-sm text-gray-500"
                                               ]
                                               [ checkbox save_the_date ]
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

let handler req =
  match Dream.session "user_id" req with
  | Some user_id ->
    let* guests = get_guests pool (int_of_string user_id) in
    Dream_html.respond (page guests)
  | None -> Dream.redirect req "/login"
;;

let auth_handler req =
  match Dream.session "user_id" req with
  | Some _ -> handler req
  | None -> Dream.redirect req "/login"
;;

let login_page req =
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
                ; class_ "block mt-1 border boder-gray-200 w-full rounded-lg"
                ]
            ; input [ type_ "submit"; value "Login" ]
            ]
        ]
    ]
;;

let login_handler req = Dream_html.respond @@ login_page req

let validate_user_credentials email password =
  let query =
    [%rapper
      get_one
        {sql|
          SELECT @int{id}
          FROM users
          WHERE email = %string{email} AND password = %string{password}
        |sql}]
  in
  let* result = Caqti_lwt.Pool.use (fun db -> query db ~email ~password) pool in
  match result with
  | Ok id -> Lwt.return id
  | _ -> Lwt.return 0
;;

let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.sql_pool "sqlite3:./registry.db"
  @@ Dream.memory_sessions
  @@ Dream.router
       [ Dream.get "/" auth_handler
       ; Dream.get "/login" login_handler
       ; Dream.post "/login" (fun request ->
           let* form_result = Dream.form request in
           match form_result with
           | `Ok [ ("email", email); ("password", password) ] ->
             let* user_id = validate_user_credentials email password in
             begin
               match user_id with
               | 0 -> Dream.redirect request "/login"
               | _ ->
                 let* _ =
                   Dream.put_session "user_id" (string_of_int user_id) request
                 in
                 Dream.redirect request "/"
             end
           | _ -> Dream.html "Invalid form")
       ; Dream.get "/styles/**" @@ Dream.static "./styles"
       ]
;;
