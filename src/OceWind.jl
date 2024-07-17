
module OceWind


# === Importing libraries ===

using Logging
using MPI



# === Importing Sub-Scripts ===

include("format_data.jl")
include("plot_data.jl")


# === Main variables ===

const nb_cores = 4
const path_script_sim = "simulation/main_sim.jl"

const sim_command = `$(mpiexec()) -n $nb_cores $(Base.julia_cmd()) --project src/$path_script_sim`


const save_file_sim = "results/data/ocean_wind_mixing_and_convection_rank"
const save_file_data = "results/data/formated_data.nc"
const save_fig_path = "results/visuals/figs_"


# === Main Function

function main()

    run(sim_command)

    @info "Simulations completed!"

    FormatData.main(nb_cores, save_file_sim, save_file_data)

    #PlotData.main(save_file_data, save_fig_path)

    @info "All done!"


end


end # module OceWind


@info "Starting the programm"

OceWind.main()
