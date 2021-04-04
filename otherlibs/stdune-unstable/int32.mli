type t = int32

include module type of struct
  include Stdlib.Int32
end
with type t := t

val compare : t -> t -> Ordering.t

val to_dyn : t -> Dyn.t

module Set : Set.S with type elt = t
module Map : Map.S with type key = t
