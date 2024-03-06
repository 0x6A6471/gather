open Lwt.Syntax
open Ppx_yojson_conv_lib.Yojson_conv.Primitives

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

let routes pool =
  [ Dream.get "/me" (fun request ->
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
            let* _ = Dream.invalidate_session request in
            let err_json = {|{ "error": "user not found" }|} in
            Dream.json ~status:`Unauthorized err_json
        end
      | None ->
        let* _ = Dream.invalidate_session request in
        Dream.json ~status:`Unauthorized "{ \"error\": \"No active session.\" }")
  ; Dream.post "/login" (fun request ->
      let* body = Dream.body request in
      let user = body |> Yojson.Safe.from_string |> user_of_yojson in
      let* user_opt = validate_user_credentials user.email user.password pool in
      match user_opt with
      | Some user ->
        let* _ = Dream.put_session "user_id" (string_of_int user.id) request in
        let user_json = yojson_of_t user in
        Dream.json (Yojson.Safe.to_string user_json)
      | None ->
        let* _ = Dream.invalidate_session request in
        let err_json = {|{ "error": "invalid credentials" }|} in
        Dream.json ~status:`Unauthorized err_json)
  ]
;;
