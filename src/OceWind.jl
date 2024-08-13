
module OceWind


# === Importing libraries ===

using Logging


# === Importing Sub-Scripts ===

include("format_data.jl")
include("plot_data.jl")


# === Main variables ===

const path_script_sim = "simulation/main_sim.jl"

const sim_command = `$(Base.julia_cmd()) --project src/$path_script_sim`


const save_file_sim = "results/data/ocean_wind_mixing_and_convection20597.nc"
const save_file_data = "results/data/formated_data.nc"
const save_fig_path = "results/visuals/figs_"


# === Main Function

function main()

    run(sim_command)

    @info "Simulations completed!"

    #FormatData.main(save_file_sim, save_file_data)

    #PlotData.main(save_file_data, save_fig_path)

    @info "All done!"


end


end # module OceWind


@info "Starting the programm"

OceWind.main()
