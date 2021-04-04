type t = int32

module D = Xxhash
module Set = Int32.Set
module Map = Int32.Map

let hash = Hashtbl.hash

let equal = Int32.equal

let file p = D.file (Path.to_string p)

let compare x y = Int32.compare x y

let to_string = Printf.sprintf "%lx"

let to_dyn s =
  let open Dyn.Encoder in
  constr "digest" [ string (to_string s) ]

let from_hex s =
  match Scanf.sscanf s "%lx" Fun.id with
  | Ok s -> Some s
  | Error _ -> None

let string = D.string

let to_string_raw s = to_string s

(* We use [No_sharing] to avoid generating different digests for inputs that
   differ only in how they share internal values. Without [No_sharing], if a
   command line contains duplicate flags, such as multiple occurrences of the
   flag [-I], then [Marshal.to_string] will produce different digests depending
   on whether the corresponding strings ["-I"] point to the same memory location
   or to different memory locations. *)
let generic a = string (Marshal.to_string a [ No_sharing ])

let file_with_stats p (stats : Unix.stats) =
  match stats.st_kind with
  | S_DIR ->
    generic (stats.st_size, stats.st_perm, stats.st_mtime, stats.st_ctime)
  | _ ->
    (* We follow the digest scheme used by Jenga. *)
    let string_and_bool ~digest_hex ~bool =
      generic (digest_hex, bool)
    in
    let content_digest = file p in
    let executable = stats.st_perm land 0o100 <> 0 in
    string_and_bool ~digest_hex:content_digest ~bool:executable
