(** get cache line size in bytes *)
val cache_line_size : unit -> int

(** create an atomic integer aligned to the cache line *)
val make : int -> int Atomic.t

(** check if integer is aligned *)
val check_aligned : int Atomic.t -> bool
