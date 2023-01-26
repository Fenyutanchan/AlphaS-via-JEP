import  Pkg
Pkg.activate(".")

using   HepMC
using   JLD2
using   JetTool
using   ProgressMeter
using   StructParticle

jet_radius      =   0.7
hepmc_file      =   "eeqqbar.hepmc"
event_file      =   "eeqqbar.event.jld2"
jet_event_file  =   "eeqqbar.jet.event.jld2"

event_list  =   read_HepMC_file(hepmc_file)
println("File $hepmc_file is read.")

p       =   Progress(length(event_list))
l       =   Threads.SpinLock()

jet_event_list  =   Vector{Event}(undef, length(event_list))

counter =   Threads.Atomic{Int}(0)
Threads.@threads for ii ∈ eachindex(event_list)
    jet_event_list[ii]    =   construct_jets_for_lepton_collision(
        event_list[ii], jet_radius
    )
    
    Threads.atomic_add!(counter, 1)
    Threads.lock(l)
    update!(p, counter[])
    Threads.unlock(l)
end
println("Jets are cosntructed.")

write_events_JLD2(event_file, event_list)
write_events_JLD2(jet_event_file, jet_event_list)
