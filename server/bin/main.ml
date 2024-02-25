open Ppx_yojson_conv_lib.Yojson_conv.Primitives

type t =
  { userId : int
  ; id : int
  ; title : string
  ; body : string
  }
[@@deriving yojson]

let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.origin_referrer_check
  @@ Dream.router
       [ Dream.get "/" (fun _request ->
           let json_string =
             {|{
                  "userId": 1,
                  "id": 1,
                  "title": "title",
                  "body": "body"
                }|}
           in
           let json = Yojson.Safe.from_string json_string in
           json |> Yojson.Safe.to_string |> Dream.json)
       ]
;;
