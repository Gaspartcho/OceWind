
module OceWind


# === Importing libraries ===

using MPI



# === Main variables ===

const nb_cores = 32
const path_script_sim = "simulation/main_sim.jl"

const sim_command = `$(mpiexec()) -n $nb_cores $(Base.julia_cmd()) --project src/$path_script_sim`


# === Main Function

function main()

    run(sim_command)

    @info "Simulations completed!"

    @info "All done!"


end


end # module OceWind


@info "Starting the programm"

OceWind.main()
