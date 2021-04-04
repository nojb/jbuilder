include Stdlib.Int32

module T = struct
  type t = int32

  let compare n m = Ordering.of_int (compare n m)

  let to_dyn n = Dyn.Encoder.int32 n
end

let compare n m = T.compare n m

let to_dyn n = T.to_dyn n

module O = Comparable.Make (T)

module Set = O.Set

module Map = O.Map
