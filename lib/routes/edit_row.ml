open Lwt.Syntax

type guest =
  { id : int
  ; name : string
  ; address : string
  ; amount : int
  ; rsvp : bool
  ; invite_sent : bool
  ; save_the_date : bool
  }

let get_guest pool id =
  let query =
    [%rapper
      get_one
        {sql| SELECT @int{id}, @string{name}, @string{address}, @int{amount}, @bool{rsvp}, @bool{invite_sent}, @bool{save_the_date} FROM guests WHERE id = %int{id} |sql}
        record_out]
  in
  let* result = Caqti_lwt.Pool.use (fun db -> query db ~id) pool in
  match result with
  | Error e -> failwith (Caqti_error.show e)
  | Ok guest -> Lwt.return guest
;;

let row _ pool =
  let open Dream_html in
  let open HTML in
  let* guest = get_guest pool 1 in
  Lwt.return
    (tr
       []
       [ td
           [ class_
               "whitespace-nowrap px-3 py-4 text-sm text-gray-900 font-bold"
           ]
           [ txt "%s" guest.name ]
       ; td
           [ class_ " px-3 py-4 text-sm text-gray-500" ]
           [ txt "%s" guest.address ]
       ; td
           [ class_ "whitespace-nowrap px-3 py-4 text-sm text-gray-500" ]
           [ input [ name "amount"; value "%i" guest.amount ] ]
       ; td
           [ class_ "whitespace-nowrap px-3 py-4 text-sm text-gray-500" ]
           [ input
               ([ type_ "checkbox"; name "rsvp"; value "1" ]
                @ if guest.rsvp then [ checked ] else [])
           ]
       ; td
           [ class_ "whitespace-nowrap px-3 py-4 text-sm text-gray-500" ]
           [ txt "%b" guest.invite_sent ]
       ; td
           [ class_ "whitespace-nowrap px-3 py-4 text-sm text-gray-500" ]
           [ txt "%b" guest.save_the_date ]
       ; td
           [ class_ "whitespace-nowrap px-3 py-4 text-sm text-gray-500" ]
           [ button
               [ Hx.put "/guests/%i" guest.id
               ; Hx.include_ "closest tr"
               ; class_
                   "rounded bg-indigo-600 px-2 py-1 text-xs font-semibold \
                    text-white shadow-sm hover:bg-indigo-500 \
                    focus-visible:outline focus-visible:outline-2 \
                    focus-visible:outline-offset-2 \
                    focus-visible:outline-indigo-600"
               ]
               [ txt "Save" ]
           ]
       ])
;;

let handler req pool =
  let* response_content = row req pool in
  Dream_html.respond
    ~status:`OK
    ~headers:[ "Content-Type", "text/html" ]
    response_content
;;

let edit_row_routes pool =
  [ Dream.get "/guests/:id/edit" (fun req -> handler req pool) ]
;;
