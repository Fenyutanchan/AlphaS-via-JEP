import  Pkg
Pkg.activate(".")

using   HepMC
using   JLD2
using   JetTool
using   ProgressMeter
using   StructParticle

jet_event_file  =   "eeqqbar.jet.event.jld2"
jet_list_file   =   "eeqqbar.jet.jld2"

function main(
    event_jld2_file_name::String,
    jet_jld2_file_name::String
)::Nothing
    event_jld2_file         =   jldopen(event_jld2_file_name, "r")
    event_jld2_file_keys    =   keys(event_jld2_file)
    
    jet_list    =   Jet[]
    @showprogress for key ∈ event_jld2_file_keys
        for jet::Jet ∈ event_jld2_file[key].Particles
            if jet.Energy ≥ 35
                push!(jet_list, jet)
            end
        end
    end

    write_jets_JLD2(jet_jld2_file_name, jet_list)
    return  nothing
end

main(jet_event_file, jet_list_file)
