include Stdune
module Log = Dune_util.Log
module Re = Dune_re
module Stringlike = Dune_util.Stringlike
module Stringlike_intf = Dune_util.Stringlike_intf
module Persistent = Dune_util.Persistent
module Value = Dune_util.Value
module Ml_kind = Dune_util.Ml_kind
module Dune_rpc = Dune_rpc_private
module Config = Dune_util.Config

(* To make bug reports usable *)
let () = Printexc.record_backtrace true

let protect = Exn.protect

let protectx = Exn.protectx

type fail = { fail : 'a. unit -> 'a }

(* Disable file operations to force to use the IO module *)
let open_in = `Use_Io

let open_in_bin = `Use_Io

let open_in_gen = `Use_Io

let open_out = `Use_Io

let open_out_bin = `Use_Io

let open_out_gen = `Use_Io

(* We open this module at the top of module generating rules, to make sure they
   don't do Io manually *)
module No_io = struct
  module Io = struct end
end
