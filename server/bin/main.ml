open Lwt.Syntax
open Ppx_yojson_conv_lib.Yojson_conv.Primitives

module type DB = Caqti_lwt.CONNECTION

module T = Caqti_type

let init_pool () =
  let uri = Uri.make ~scheme:"sqlite3" ~path:"./registry.db" () in
  match Caqti_lwt.connect_pool ~max_size:10 uri with
  | Ok pool -> pool
  | Error err -> failwith (Caqti_error.show err)
;;

let pool = init_pool ()

type t =
  { id : int
  ; email : string
  }
[@@deriving yojson]

type user =
  { email : string
  ; password : string
  }
[@@deriving yojson]

let find_user_by_id id pool =
  let query =
    [%rapper
      get_one
        {sql| SELECT @int{id}, @string{email} FROM users WHERE id = %int{id} |sql}
        record_out]
  in
  let* result = Caqti_lwt.Pool.use (fun db -> query db ~id) pool in
  match result with
  | Ok user -> Lwt.return (Some user)
  | Error _ -> Lwt.return None
;;

let validate_user_credentials email password pool =
  let query =
    [%rapper
      get_one
        {sql| SELECT @int{id}, @string{email} FROM users WHERE email = %string{email} AND password = %string{password} |sql}
        record_out]
  in
  let* result = Caqti_lwt.Pool.use (fun db -> query db ~email ~password) pool in
  match result with
  | Ok user -> Lwt.return (Some user)
  | Error _ -> Lwt.return None
;;

let cors_middleware inner_handler req =
  let new_headers =
    [ "Allow", "OPTIONS, GET, HEAD, POST"
    ; "Access-Control-Allow-Origin", "http://localhost:5173"
    ; "Access-Control-Allow-Methods", "OPTIONS, GET, POST, DELETE, PUT"
    ; "Access-Control-Allow-Headers", "Content-Type, Accept"
    ; "Access-Control-Allow-Credentials", "true"
    ]
  in
  match Dream.method_ req with
  | `OPTIONS -> Dream.respond ~headers:new_headers ""
  | _ ->
    let* response = inner_handler req in
    let response_with_headers =
      List.fold_left
        (fun resp (key, value) ->
          Dream.add_header resp key value;
          resp)
        response
        new_headers
    in
    Lwt.return response_with_headers
;;

let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.sql_pool "sqlite3:./registry.db"
  (* @@ Dream.origin_referrer_check *)
  @@ Dream.sql_sessions ~lifetime:3600.0
  @@ cors_middleware
  @@ Dream.router
       [ Dream.get "/" (fun _request ->
           let json_string = {|{ "status": "ok" }|} in
           let json = Yojson.Safe.from_string json_string in
           json |> Yojson.Safe.to_string |> Dream.json)
         (*TODO: add a get request to validate?
           * maybe just try and log the request and see if we can get the dream session
           * try just returning the dream session
         *)
       ; Dream.get "/me" (fun request ->
           let session = Dream.session "user_id" request in
           match session with
           | Some user_id ->
             let user_id = int_of_string user_id in
             let* user_opt = find_user_by_id user_id pool in
             begin
               match user_opt with
               | Some user ->
                 let user_json = yojson_of_t user in
                 Dream.json (Yojson.Safe.to_string user_json)
               | None ->
                 let err_json = {|{ "error": "user not found" }|} in
                 Dream.json ~status:`Unauthorized err_json
             end
           | None ->
             Dream.json
               ~status:`Unauthorized
               "{ \"error\": \"No active session.\" }")
       ; Dream.post "/login" (fun request ->
           let* body = Dream.body request in
           let user = body |> Yojson.Safe.from_string |> user_of_yojson in
           let* user_opt =
             validate_user_credentials user.email user.password pool
           in
           match user_opt with
           | Some user ->
             let* _ =
               Dream.put_session "user_id" (string_of_int user.id) request
             in
             let user_json = yojson_of_t user in
             Dream.json (Yojson.Safe.to_string user_json)
           | _ ->
             let err_json = {|{ "error": "invalid credentials" }|} in
             Dream.json ~status:`Unauthorized err_json)
       ]
;;
