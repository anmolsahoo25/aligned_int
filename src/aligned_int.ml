external cache_line_size : unit -> int = "caml_cache_line_size"

external make : int -> int Atomic.t = "caml_aligned_int"

external check_aligned : int Atomic.t -> bool = "caml_check_aligned"
