open Lwt.Syntax

type t =
  { id : int
  ; name : string
  ; address : string
  ; amount : int
  ; rsvp : bool
  ; invite_sent : bool
  ; save_the_date : bool
  }

let get_guest req pool =
  let id = Dream.param req "id" |> int_of_string in
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
