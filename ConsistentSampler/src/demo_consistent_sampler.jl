include("consistent_sampler.jl")
function demo_sampler()
   "Illustrates use of consistent_sampler.sampler"

   println("demo_sampler.")
   println("\n    Example X1: Shuffling a list of size six.")
   println("""
   >>> for id in sampler(["A-1", "A-2", "A-3",
                          "B-1", "B-2", "B-3"],
                         seed=314159,
                         output="id"):
           println(id)
   """)
   for id in sampler(["A-1", "A-2", "A-3","B-1", "B-2", "B-3"],seed=314159,output="id")
       println(id)
end

   println("\n    Example X2: Taking sample of size 3 (prefix of shuffled list).")
   println("""
   >>> for id in sampler(["A-1", "A-2", "A-3",
                          "B-1", "B-2", "B-3"],
                         seed=314159,
                         output="id",
                         take=3):
           println(id)
   """)
   for id in sampler(["A-1", "A-2", "A-3","B-1", "B-2", "B-3"],seed=314159,output="id",take=3)
       println(id)
end
   println("\n    Example X3: Demonstrating consistency: shuffling the B items only.")
   println("""
   >>> for id in sampler(["B-1", "B-2", "B-3"],
                         seed=314159,
                         output="id"):
           println(id)
   """)
   for id in sampler(["B-1", "B-2", "B-3"],
                     seed=314159,
                     output="id")
       println(id)
end
   println("\n    Example X4: Same as example X1, but showing tickets in sorted order.")
   println("    Each ticket has: ticket_number, id, and generation.")
   println("""
   >>> for tkt in sampler(["A-1", "A-2", "A-3",
                          "B-1", "B-2", "B-3"],
                          seed=314159):
           println(tkt)
   """)
   for tkt in sampler(["A-1", "A-2", "A-3",
                       "B-1", "B-2", "B-3"],
                     seed=314159)
       println(tkt)
end
   println("\n    Example X5: Same as example X2, but showing tickets in sorted order.")
   println("""
   >>> for tkt in sampler(["B-1", "B-2", "B-3"],
                          seed=314159):
           println(tkt)
   """)
   for tkt in sampler(["B-1", "B-2", "B-3"],
                      seed=314159)
       println(tkt)
end
   println("\n    Example X6: Drawing sample of size 16 with replacement from set of size 6.")
   println("""
   >>> for tkt in sampler(["A-1", "A-2", "A-3",
                           "B-1", "B-2", "B-3"],
                          seed=314159,
                          with_replacement=true,
                          take=16):
           println(tkt)
   """)
   for tkt in sampler(["A-1", "A-2", "A-3",
                       "B-1", "B-2", "B-3"],
                      seed=314159,
                      with_replacement=true,
                      take=16)
       println(tkt)
end

   println("\n    Example X7: Drawing sample of size 16 with replacement from set of size 3.")
   println("    Note consistency with example X6.")
   println("""
   >>> for tkt in sampler(["B-1", "B-2", "B-3"],
                          seed=314159,
                          with_replacement=true,
                          take=16):
           println(tkt)
   """)
   for tkt in sampler(["B-1", "B-2", "B-3"],
                      seed=314159,
                      with_replacement=true,
                      take=16)
       println(tkt)
    end
   println("\n    Example X8: Drawing sample of size 16 with replacement from set of size 1.")
   println("    Note consistency with examplex X6 and X7.")
   println("""
   >>> for tkt in sampler(["B-1"],
                          seed=314159,
                          with_replacement=true,
                          take=16):
           println(tkt)
   """)
   for tkt in sampler(["B-1"],
                      seed=314159,
                      with_replacement=true,
                      take=16)
       println(tkt)
end
end

function demo_fraction()

   println("demo_fraction: First pseudorandom fraction.")
   println(">>> first_fraction('C-14', 314159)")
   x = first_fraction("C-14", "314159")
   println(x)

   println("20 subsequent invocations of 'next_fraction':")
   println("""
         >>> for i in range(20):
         >>>    x = next_fraction(x)
         >>>    println(x)
         """)
   for i in 1:20
       x = next_fraction(x)
       println(x)
    end
end
demo_sampler()
demo_fraction()
