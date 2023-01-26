script_dir  =   dirname(@__FILE__)
workspace   =   dirname(script_dir)
julia_path  =   joinpath(
    Sys.BINDIR,
    Base.julia_exename()
)

job_name            =   "Preparation"
julia_script_list   =   [
    "FromHepMC2JLD.jl",
    "GenerateJet.jl"
]
num_cpu     =   20
num_gpu     =   0
mem_per_cpu =   "9GB"
log_dir     =   script_dir

main_content_list   =   [
    "$julia_path -t $num_cpu $workspace/$julia_script"
    for julia_script ∈ julia_script_list
]
main_content        =   join(main_content_list, "\n")

script  =   """
#!/bin/bash
#SBATCH --partition=pqcdgpu
#SBATCH --qos=pqcdnormal
#SBATCH --account=pqcd
#SBATCH --job-name=$job_name
#SBATCH --ntasks=$num_cpu
#SBATCH --output=$log_dir/$job_name.log
#SBATCH --mem-per-cpu=$mem_per_cpu
#SBATCH --gres=gpu:v100:$num_gpu

######################

cd $workspace
$main_content

"""

open(
    joinpath(
        script_dir,
        "$job_name.sh"
    ),
    "w+"
) do io
    write(io, script)
end

chmod(
    joinpath(
        script_dir,
        "$job_name.sh"
    ),
    0o755
)
