let producer q () =
    for _ = 0 to 100000000 do
        while (not (Spsc_queue.enqueue q 0)) do
            ()
        done
    done

let consumer q () =
    let pop_cnt = ref 0 in
    while (!pop_cnt < 100000000) do
        match Spsc_queue.dequeue q with
        | None -> ()
        | Some _ -> pop_cnt := !pop_cnt + 1
    done;
    !pop_cnt

let () =
    Printf.printf "spsc queue benchmark\n";
    Printf.printf "====================\n";

    (* read command line arguments *)
    let aligned = Sys.argv.(1) |> int_of_string in

    match aligned with
    | 0 -> begin
        Printf.printf "case: unaligned head/tail\n";
        let q = Spsc_queue.init ~size_exponent:10 ~align:false () in
        let d1 = Domain.spawn (consumer q) in
        let d2 = Domain.spawn (producer q) in
        Domain.join d2;
        Printf.printf "Popped: %d\n" (Domain.join d1)
    end
    | 1 -> begin
        Printf.printf "case: aligned head/tail\n";
        let q = Spsc_queue.init ~size_exponent:10 ~align:true () in
        let d1 = Domain.spawn (consumer q) in
        let d2 = Domain.spawn (producer q) in
        Domain.join d2;
        Printf.printf "Popped: %d\n" (Domain.join d1)
    end
    | _ -> Printf.printf "unknown case for aligned. Exiting..."
