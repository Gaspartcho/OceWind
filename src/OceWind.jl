
module OceWind


# === Importing libraries ===

using Logging


# === Main variables ===

const path_script_sim = "simulation/main_sim.jl"

const sim_command = `$(Base.julia_cmd()) --project src/$path_script_sim`


# === Main Function

function main()
	
    for _ in 1:5
       run(sim_command)
    end

    @info "Simulations completed!"

    @info "All done!"


end


end # module OceWind


@info "Starting the programm"

OceWind.main()
