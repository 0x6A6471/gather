open Routes

module type DB = Caqti_lwt.CONNECTION

module T = Caqti_type

let init_pool () =
  let uri = Uri.make ~scheme:"sqlite3" ~path:"./registry.db" () in
  match Caqti_lwt.connect_pool ~max_size:10 uri with
  | Ok pool -> pool
  | Error err -> failwith (Caqti_error.show err)
;;

let pool = init_pool ()

let () =
  Dream.run ~interface:"0.0.0.0"
  @@ Dream.logger
  @@ Dream_livereload.inject_script ()
  @@ Dream.sql_pool "sqlite3:./registry.db"
  @@ Dream.memory_sessions
  @@ Dream.router
       ([ Dream.get "/styles/**" @@ Dream.static "./styles"
        ; Dream_livereload.route ()
        ]
        @ Login.login_routes pool
        @ Home.home_routes pool)
;;
