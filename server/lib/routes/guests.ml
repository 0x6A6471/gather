open Lwt.Syntax
open Ppx_yojson_conv_lib.Yojson_conv.Primitives

type t =
  { id : int
  ; name : string
  ; address : string
  ; city : string
  ; state : string
  ; zip : string
  ; guest_amount : int
  ; rsvp_sent : int
  ; invite_sent : int
  ; save_the_date_sent : int
  }
[@@deriving yojson]

let get_guests_by_user_id user_id pool =
  let query =
    [%rapper
      get_many
        {sql| SELECT @int{id}, @string{name}, @string{address}, @string{city}, @string{state}, @string{zip}, @int{guest_amount}, @int{rsvp_sent}, @int{invite_sent}, @int{save_the_date_sent} FROM guests WHERE user_id = %int{user_id} |sql}
        record_out]
  in
  let* result = Caqti_lwt.Pool.use (fun db -> query db ~user_id) pool in
  match result with
  | Ok guests -> Lwt.return (Some guests)
  | Error _ -> Lwt.return (Some [])
;;

let routes pool =
  [ Dream.get "/guests" (fun request ->
      let session = Dream.session "user_id" request in
      match session with
      | Some user_id ->
        let user_id = int_of_string user_id in
        let* guests = get_guests_by_user_id user_id pool in
        begin
          match guests with
          | Some guests ->
            let guests_json = `List (List.map yojson_of_t guests) in
            Dream.json (Yojson.Safe.to_string guests_json)
          | None -> assert false
        end
      | None -> assert false)
  ]
;;
