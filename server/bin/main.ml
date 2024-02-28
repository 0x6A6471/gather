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

let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.sql_pool "sqlite3:./registry.db"
  (* @@ Dream.origin_referrer_check *)
  (* @@ Dream.sql_sessions ~lifetime:3600.0 *)
  @@ Dream.router
       [ Dream.get "/" (fun _request ->
           let json_string = {|{ "status": "ok" }|} in
           let json = Yojson.Safe.from_string json_string in
           json |> Yojson.Safe.to_string |> Dream.json)
       ; Dream.post "/login" (fun request ->
           let* body = Dream.body request in
           let user = body |> Yojson.Safe.from_string |> user_of_yojson in
           let* user_opt =
             validate_user_credentials user.email user.password pool
           in
           match user_opt with
           | Some user ->
             let user_json = yojson_of_t user in
             Dream.json (Yojson.Safe.to_string user_json)
           | _ ->
             let err_json = {|{ "error": "invalid credentials" }|} in
             Dream.json ~status:`Unauthorized err_json)
       ]
;;
