

module MainSim


# === Importing libraries ===

using Oceananigans
using Logging



# === Importing Sub-Scripts ===

include("grid.jl")
include("model.jl")
include("simulation.jl")



# === Constant Variables

const filepath = "results/data/ocean_wind_mixing_and_convection"
const world_size = 128
const duration = 60
const show_objects = true
const time_result_path = "results/logs/time.txt"


# === Main Function ===

function main()

	Logging.global_logger(OceananigansLogger())

	grid = Grid.main(world_size, show_objects)

	model = Model.main(grid, show_objects)

	filename = string(filepath, ".nc") #so I can run multiple in parallell

	simulation = Sim.main(model, duration, filename, show_objects)

	run!(simulation)

end


end # module

println("Starting the simulation\n")

MainSim.main()
