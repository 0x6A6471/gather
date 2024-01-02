open Lwt.Syntax

let login_handler req = Dream_html.respond @@ Views.Login.page req

let validate_user_credentials email password pool =
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

let login_routes pool =
  [ Dream.get "/login" login_handler
  ; Dream.post "/login" (fun request ->
      let* form_result = Dream.form request in
      match form_result with
      | `Ok [ ("email", email); ("password", password) ] ->
        let* user_id = validate_user_credentials email password pool in
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
  ]
;;
