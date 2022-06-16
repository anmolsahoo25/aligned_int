let test1 () =
    (* test 1: check if init value is 0 *)
    Printf.printf "test1: check if init value correct ";
    let x = Aligned_int.make 0 in
    let y = Aligned_int.make 128 in
    try begin
        assert (Atomic.get x = 0);
        assert (Atomic.get y = 128);
        Printf.printf "[passed]\n"
    end with _ -> Printf.printf "[failed]\n"

let test2 () =
    (* test 2: incr by 100 and check *)
    Printf.printf "test2: incr/decr by 100 and check value ";
    let x = Aligned_int.make 0 in
    let y = Aligned_int.make 100 in
    for _ = 1 to 100 do
        let _ = Atomic.fetch_and_add x 1 in
        let _ = Atomic.fetch_and_add y (-1) in
        ()
    done;
    try begin
        assert (Atomic.get x = 100);
        assert (Atomic.get y = 0);
        Printf.printf "[passed]\n"
    end with _ -> Printf.printf "[failed]\n"

let test3 () =
    (* address aligned to 128B boundary *)
    Printf.printf "test3: test raw object properties ";
    let x = Aligned_int.make 100 in
    let repr = x |> Obj.repr in
    let size = Aligned_int.cache_line_size () in
    try begin
        assert (Obj.tag repr = Obj.abstract_tag);
        assert (Obj.size repr = (size / 8));
        assert (Aligned_int.check_aligned x = true);
        Printf.printf "[passed]\n"
    end with _ -> Printf.printf "[failed]\n"

let () =
    Printf.printf "Running aligned int tests\n";
    Printf.printf "Cache line size: %d\n" (Aligned_int.cache_line_size ());
    test1 ();
    test2 ();
    test3 ()
