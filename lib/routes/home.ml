open Lwt.Syntax

let get_guests pool user_id =
  let query =
    [%rapper
      get_many
        {sql| SELECT @string{name}, @string{address}, @int{amount}, @bool{rsvp}, @bool{invite_sent}, @bool{save_the_date} FROM guests WHERE user_id = %int{user_id} |sql}]
  in
  let* result = Caqti_lwt.Pool.use (fun db -> query db ~user_id) pool in
  match result with
  | Error e -> failwith (Caqti_error.show e)
  | Ok guests -> Lwt.return guests
;;

let handler req pool =
  match Dream.session "user_id" req with
  | Some user_id ->
    let* guests = get_guests pool (int_of_string user_id) in
    Dream_html.respond (Views.Index.page guests)
  | None -> Dream.redirect req "/login"
;;

let auth_handler req pool =
  match Dream.session "user_id" req with
  | Some _ -> handler req pool
  | None -> Dream.redirect req "/login"
;;

let home_routes pool = [ Dream.get "/" (fun req -> auth_handler req pool) ]
