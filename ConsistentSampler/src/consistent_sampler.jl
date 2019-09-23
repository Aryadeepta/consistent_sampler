using SHA
import Base.println
import Base.string
using Documenter
# Creating the Ticket Struct
export Ticket,copyTicket,println,string,trim,Duplicates,sha256_hex,sha256_uniform,first_fraction,nextTicket,make_ticket_priority_queue,withoutReplacement,withReplacement,sampler
"""
    Ticket
A struct which stores a ticket number, id, and generation
"""
mutable struct Ticket
    ticket_number::String
    id
    generation::Int
    Ticket(id,seed::Any,seed_hash::String="unknown")=new(first_fraction(id,seed,seed_hash),id,1)
end
#= Creating a copy of a ticket
    input:
        t=Ticket (the ticket being copied)
    output:
        A copy of the ticket
    ex:
    julia> t = Ticket("test","seed")
        Ticket("0.33630059932019788362871127560516782435811639372747056958999302827432497242309", "test", 1)
    julia> copyTicket(t)
        Ticket("0.33630059932019788362871127560516782435811639372747056958999302827432497242309", "test", 1)
=#
"""
    copyTicket(t::Ticket)
Returns a copy of the ticket 't'
"""
function copyTicket(t::Ticket)
    n = Ticket(t.id,"")
    n.ticket_number=t.ticket_number
    n.generation=t.generation
    return(n)
end

#Prints the fields of the tickets as well as their values
"""
    println(t::Ticket)
Prints out the values of a ticket on a line
"""
function println(t::Ticket)
    println("Ticket(ticket_number="*t.ticket_number*", id="*string(t.id)*", generation="*string(t.generation)*")")
end

#Puts the fields in the string form of the tickets
"""
    string(t::Ticket)
Returns a string version of a Ticket
"""
function string(t::Ticket)
    return("Ticket(ticket_number="*t.ticket_number*", id="*string(t.id)*", generation="*string(t.generation)*")")
end

#= trims a decimal to the amount, default value is 9
        input:
            x=The decimal in string form
            length = length to trim the string,default value 9
        output:
            x trimmed to l places after decimal after the first continuous string of 9s
        ex:
        julia> trim("0.0123456789",2)
            "0.01"

        julia> trim("0.99999999901234567899999",2)
            "0.99999999901"
=#
"""
    trim(x::String,length::Int=9)
Trims a string 'x' to 'length' (defaulted to 9) digits after the last consecutive 9 after decimal
"""
function trim(x::String,length::Int=9)
   f=0
   x=x*"0"
   for i in 3:lastindex(x)
       try
           if x[i]!='9' && f==0
               f=i
           end
       catch
       end
    end
    try
        return(x[1:f+length-1])
    catch
        return(x)
    end
end

#=
    returns an array of all the duplicate values of an array
    input:
        L=the array from which duplicates will be found
    output:
        an array of duplicates
    ex:
    julia> Duplicates([1,2,3,4])
        0-element Array{Any,1}

    julia> Duplicates([1,9,2,3,4,2,5,9])
        2-element Array{Any,1}:
        2
        9
=#
#=
'''jldoctest
julia> 1+2
2
'''
=#
"""
    Duplicates(L::AbstractArray)
Returns an array of all the duplicates in the array L
"""
function Duplicates(L::AbstractArray)
    seen = Any[]
    duplicates = Any[]
    for i in L
        if (i in seen) && !(i in duplicates)
            push!(duplicates,i)
        else
            push!(seen,i)
        end
    end
    return(duplicates)
end

#=
    Returns the SHA256 hash for an input in hexadecimal form
    input:
        h=value to be hashed
    output:
        hexadecimal form of sha256 hashing of h
    ex:
        julia> sha256_hex("0.123")
            "cbe4acd2532c89433c3e0fde332c89467c2356b2a0c8013e414949bb175dee82"
=#
"""
    sha256_hex(h)
Returns the hexadecimal form of the sha256(h)
"""
function sha256_hex(h)
    return(bytes2hex(sha2_256(h)))
end

#=
    takes input and creates decimal using sha256
    input:
        h= value to be hashed
    output:
        unique decomal created using sha256 hash of h
    ex:
    julia> sha256_uniform("0.123")
        "0.83552498021283174783103891591311143453114372098189519311767873229836124532229"
=#
"""
    sha256_uniform(h)
Returns a decimal point followed by the string form of the digits of the decimal form of sha256_uniform(h) in reverse order
"""
function sha256_uniform(h)
    return("0."*reverse(string(parse(BigInt,"0x"*string(sha256_hex(h))))))
end

#=
    creates a decimal using the sha_256 of a combination of an id and a seed
    inputs:
        id=the id of the ticket
        seed=the seed for the ticket
        seed _hash=the hash of the seed if known, used for doing the process many times with the same seed so it only gets hashed once (set to "unknown")
    output:
        a unique decimal (in String form) which is made using the id and seed, trimmed to the length of digits
    ex:
    julia> first_fraction("test","123")
        "0.0015833438888868526337983863851845935895165130746419950410837701672024435111"
=#
"""
    first_fraction(id,seed,seed_hash::String="unknown")
Returns the sha256*_*uniform of the id and sha256*_*uniform of the seed, which can also be directly implemented as seed_hash to save time for repetetive use
"""
function first_fraction(id,seed::Any,seed_hash::String="unknown")
    if(seed_hash=="unknown")
        seed_hash=sha256_hex(seed)
    end
    return(sha256_uniform(string(seed_hash)*string(id)))
end

#=
    using the previous fraction, it creates another one that is larger
    inputs:
        x=previous fraction
    output:
        a decimal in String form which is greater than x
    ex:
    julia> next_fraction("0.123")
        "0.44384995535085584552826468098417938608857919161425616035129739781893136007312"
=#
"""
    next_fraction(x::String)
Returns the first sha256_uniform of a String followed by an increasing number which is greater than the original String
"""
function next_fraction(x::String)
    y="0."
    i=0
    while y<=x
        i=i+1
        y=trim(x,0)
        y=y*sha256_uniform(x*":"*string(i))[3:end]
    end
    return(y)
end

#=
    using a Ticket, the next_fraction function is performed on its ticket number, and its generation is increased by 1
    inputs:
        t=previous Ticket
    output:
        a Ticket with 1 added to its generation, and with a higher ticket number
    ex:
    julia> t = Ticket("test","seed")
        Ticket("0.33630059932019788362871127560516782435811639372747056958999302827432497242309", "test", 1)

    julia> nextTicket(t)
        Ticket("0.92003752347350580442198013061725223804051274715203944854727220228097953968637", "B-2", 3)
=#
"""
    nextTicket(t::Ticket)
Returns a ticket with 1 added to the generation, and the ticket_number being set to next_fraction of the current ticket number
"""
function nextTicket(t::Ticket)
    t.ticket_number=next_fraction(t.ticket_number)
    t.generation+=1
    return(t)
end

#=
    using an array of ids, a ticket is made for each and put into a priority queue
    inputs:
        idlist=list of ids
        seed=seed used for ticket numbers
    output:
        priority queue of Tickets for each id, with the ticket numbers being the values
    ex:
    julia> make_ticket_priority_queue(["test 1","test 2","test 3"],"0.123")
        3-element Array{Ticket,1}:
        Ticket("0.32133658415916556297065243346336210541398813507378513441955184470792084622814", "test 3", 1)
        Ticket("0.705711711782285460214047615568918714032180663101356794863431656416382396385501", "test 1", 1)
        Ticket("0.81831561472188112226616019848243032531669254067161712990661965478386300786272", "test 2", 1)
=#
"""
    make_ticket_priority_queue(idlist::AbstractArray,seed)
Returns a priority queue with the values being tickets made with an id from idlist and a seed of seed, and their corresponding keys being their ticket_number
"""
function make_ticket_priority_queue(idlist::AbstractArray,seed::Any)
    pq = Ticket[]
    sh = sha256_hex(seed)
    for id in idlist
        t = Ticket(id,seed,sh)
        pq = push!(pq,t)
    end
    return(sort!(pq, by = x -> x.ticket_number))
end

#=
    creates a list of tiickets without replacement
    input:
        t= a priority queue of tickets
        l = the number of tickets choosen
    output:
        the first l inexes of the priority queue
    ex:
    julia> withoutReplacement(make_ticket_priority_queue(["test 1","test 2","test 3"],"0.123"),2)
        2-element Array{Ticket,1}:
        Ticket("0.32133658415916556297065243346336210541398813507378513441955184470792084622814", "test 3", 1)
        Ticket("0.705711711782285460214047615568918714032180663101356794863431656416382396385501", "test 1", 1)

=#
"""
    withoutReplacement(t::Array{Ticket},l::Int)
Returns the first l indices of T
"""
function withoutReplacement(t::Array{Ticket},l::Int)
    return t[1:l]
end

#=
    creates a list of tickets without replacement
    input:
        t= a priority queue of tickets
        l = the number of tickets choosen
    output:
        the first l tickets choosen, but when a ticket is choosen, it becomes the nextTicket of itself
    ex:
    julia> withReplacement(make_ticket_priority_queue(["test 1","test 2","test 3"],"0.123"),5)
        5-element Array{Ticket,1}:
        Ticket("0.32133658415916556297065243346336210541398813507378513441955184470792084622814", "test 3", 1)
        Ticket("0.705711711782285460214047615568918714032180663101356794863431656416382396385501", "test 1", 1)
        Ticket("0.76816082937875020387948070168106848348636547093195185928775277952597567907628", "test 3", 2)
        Ticket("0.809438831231461520951096475358574085418061558256190391042220796894800518210201", "test 1", 2)
        Ticket("0.81831561472188112226616019848243032531669254067161712990661965478386300786272", "test 2", 1)
=#
"""
    withReplacement(t::Array{Ticket},l::Int)
Returns an array of l tickets, but every time a ticket is put in this array, its value is put back into t as nextTicket of itself
"""
function withReplacement(t::Array{Ticket},l::Int)
    x = Ticket[]
    while length(x)<l
        push!(x,copyTicket(t[1]))
        t[1] = nextTicket(t[1])
        sort!(t, by = a -> a.ticket_number)
    end
    return x
end

#=
    The sampler will return a sample of tickets, with or without replacement, of an array of ids
    inputs:
        ids=the array of ids
        seed=the seed used in sha256_uniform
        take=the number of tickets in the output
        with_replacement=whether or not the output will use replacement
        drop=the number of tickets to be dropped before the sampler takes
        output=whether the output is in tuple, Ticket, or id form
        digits=the number of digits to trim ticket numbers to
    output:
        a list of Tickets,tuples, or ids taken from the withReplacement or withoutReplacement of the make_ticket_priority_queue of the ids, seed, and digits and length drop+take, without the first drop indexes
    ex:
    julia> sampler(["1","2","3"],seed="123",take=3,output="id")
        3-element Array{Any,1}:
        "2"
        "3"
        "1"

    julia> sampler(["1","2","3"],seed="123",take=2,drop=1)
    ("0.831842660", "3", 1)
    ("0.891142008", "1", 1)

    julia> sampler(["1","2","3"],seed="123",take=5,with_replacement=true,output="Ticket",digits=5)
        5-element Array{Ticket,1}:
        Ticket("0.73290", "2", 1)
        Ticket("0.83184", "3", 1)
        Ticket("0.89114", "1", 1)
        Ticket("0.907418", "2", 2)
        Ticket("0.929981", "1", 2)
=#
"""
    sampler(ids::AbstractArray,; seed::Any=nothing, take::Int=length(ids),with_replacement=false,drop::Int=0,output="tuple",digits::Int=9)
Returns the withoutReplacement or withReplacement function of a priority queue of tickets, made by make*_*ticket*_*priority*_*queue(ids,seed), with length of drop+take, with the first drop idexes removed, outputted in output form (Ticket,tuple, or ids), with the ticket_numbers trimmed to 'digits' digits
"""
function sampler(ids::AbstractArray,; seed::Any=nothing, take::Int=length(ids),with_replacement=false,drop::Int=0,output="tuple",digits::Int=9)
    seed=string(seed)
    if seed==nothing
        error("Must have seed.")
    end
    if length(Duplicates(ids))>0
        error("No duplicates in ids.")
    end
    if output!="tuple" && output!="Ticket" && output!="id"
        error("Output must be 'tuple' or 'Ticket'.")
    end
    if take <=0
        error("Take must be at least 1.")
    end
    if digits <=0
        error("Digits must be at least 1.")
    end
    if drop<0
        error("Drop must be positive.")
    end
    if !with_replacement && (drop+take>length(ids))
        error("Not enough ids.")
    end
    t = make_ticket_priority_queue(ids,seed)
    a = Ticket[]
    if with_replacement
        x = withReplacement(t,drop+take)
    else
        x = withoutReplacement(t,drop+take)
    end
    a=x[drop+1:drop+take]
    for i in a
        i.ticket_number=trim(i.ticket_number,digits)
    end
    if output=="Ticket"
        return(a)
    end
    if output == "id"
        fid = []
        for i in a
            push!(fid,i.id)
        end
        return(fid)
    end
    tp = []
    for tk in a
        t = tuple(tk.ticket_number,tk.id,tk.generation)
        push!(tp,t)
    end
    return tp
end
