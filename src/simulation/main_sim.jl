

module MainSim


# === Importing libraries ===

using Oceananigans
using Logging



# === Importing Sub-Scripts ===

include("grid.jl")
include("model.jl")
include("simulation.jl")



# === Constant Variables

const filepath = "results/data/ocean_wind_mixing_and_convection_large.nc"
const world_size = 256
const duration = 1200
const show_objects = true


# === Main Function ===

function main()

	Logging.global_logger(OceananigansLogger())

	grid = Grid.main(world_size, show_objects)

	model = Model.main(grid, show_objects)

	simulation = Sim.main(model, duration, filepath, show_objects)

	run!(simulation)

end


end # module

println("Starting the simulation\n")

MainSim.main()
