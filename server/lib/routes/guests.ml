open Lwt.Syntax
open Ppx_yojson_conv_lib.Yojson_conv.Primitives

type t =
  { id : int
  ; user_id : int
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

type add_t =
  { name : string
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

let get_guests_by_user_id uid pool =
  let query =
    [%rapper
      get_many
        {sql| SELECT @int{id}, @int{user_id}, @string{name}, @string{address}, @string{city}, @string{state}, @string{zip}, @int{guest_amount}, @int{rsvp_sent}, @int{invite_sent}, @int{save_the_date_sent} FROM guests WHERE user_id = %int{uid} ORDER BY created_at DESC |sql}
        record_out]
  in
  let* result = Caqti_lwt.Pool.use (fun db -> query db ~uid) pool in
  match result with
  | Ok guests -> Lwt.return (Some guests)
  | Error _ -> Lwt.return (Some [])
;;

let add_guest
  ~user_id
  ~name
  ~address
  ~city
  ~state
  ~zip
  ~guest_amount
  ~rsvp_sent
  ~invite_sent
  ~save_the_date_sent
  pool
  =
  let query =
    [%rapper
      execute
        {sql|
      INSERT INTO guests (user_id, name, address, city, state, zip, guest_amount, rsvp_sent, invite_sent, save_the_date_sent)
      VALUES (%int{user_id}, %string{name}, %string{address}, %string{city}, %string{state}, %string{zip}, %int{guest_amount}, %int{rsvp_sent}, %int{invite_sent}, %int{save_the_date_sent})
      |sql}]
  in
  let* result =
    Caqti_lwt.Pool.use
      (fun db ->
        query
          db
          ~user_id
          ~name
          ~address
          ~city
          ~state
          ~zip
          ~guest_amount
          ~rsvp_sent
          ~invite_sent
          ~save_the_date_sent)
      pool
  in
  match result with
  | Ok _ -> Lwt.return (Some ())
  | Error _ -> Lwt.return None
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
  ; Dream.post "/guests" (fun request ->
      let session = Dream.session "user_id" request in
      match session with
      | Some user_id ->
        let user_id = int_of_string user_id in
        let* body = Dream.body request in
        let guest = add_t_of_yojson (Yojson.Safe.from_string body) in
        let* _ =
          add_guest
            ~user_id
            ~name:guest.name
            ~address:guest.address
            ~city:guest.city
            ~state:guest.state
            ~zip:guest.zip
            ~guest_amount:guest.guest_amount
            ~rsvp_sent:guest.rsvp_sent
            ~invite_sent:guest.invite_sent
            ~save_the_date_sent:guest.save_the_date_sent
            pool
        in
        Dream.json {|{ "status": "ok" }|}
      | None -> Dream.json {|{ "status": "error" }|})
  ]
;;
