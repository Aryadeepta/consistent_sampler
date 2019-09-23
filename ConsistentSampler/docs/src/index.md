# consistent_sampler.jl Documentation
## Ticket
```@docs
Ticket
copyTicket(::Ticket)
println(::Ticket)
string(::Ticket)
nextTicket(::Ticket)
make_ticket_priority_queue(::AbstractArray,seed)
```
## Formatting
```@docs
trim(::String,::Int)
Duplicates(::AbstractArray)
```
## Hashing
```@docs
sha256_hex(h)
sha256_uniform(h)
first_fraction(id,seed::Any,seed_hash::String)
next_fraction(::String)
```
## With/Without Replacement
```@docs
withoutReplacement(::Array{Ticket},::Int)
withReplacement(::Array{Ticket},::Int)
```
## Sampler
```@docs
sampler(ids::AbstractArray,; seed::Any=nothing, take::Int=length(ids),with_replacement=false,drop::Int=0,output="tuple",digits::Int=9)
```
