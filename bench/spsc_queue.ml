(* Code taken from: https://github.com/bartoszmodelski/ebsl *)

type 'a t = {
  array : 'a Option.t Array.t;
  tail : int Atomic.t;
  head : int Atomic.t;
  mask : int;
}

let init ?(size_exponent=10) ?(align=true) () =
  let size = Int.shift_left 1 size_exponent in
  { head = if align then Aligned_int.make 0 else Atomic.make 0;
    tail = if align then Aligned_int.make 0 else Atomic.make 0;
    mask = size - 1;
    array = Array.init size (fun _ -> None); 
  };;

let enqueue {array; head; tail; mask} element =
  let size = mask + 1 in
  let head_val = Atomic.get head in 
  let tail_val = Atomic.get tail in 
  if head_val + size == tail_val
  then false 
  else (
    Array.set array (tail_val land mask) (Some element); 
    Atomic.set tail (tail_val + 1);
    true)

let dequeue {array; head; tail; mask} =
  let head_val = Atomic.get head in 
  let tail_val = Atomic.get tail in 
  if head_val == tail_val
  then None
  else (
    let index = head_val land mask in 
    let v = Array.get array index in
    (* allow gc to collect it *)
    Array.set array index None;
    Atomic.set head (head_val + 1);
    assert (Option.is_some v);
    v)
