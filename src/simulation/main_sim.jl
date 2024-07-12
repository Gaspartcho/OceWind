

module MainSim


# === Importing libraries ===

using MPI
using Oceananigans
using Logging



# === Importing Sub-Scripts ===

include("arch.jl")
include("grid.jl")
include("model.jl")
include("simulation.jl")



# === Constant Variables

const filepath = "results/data/ocean_wind_mixing_and_convection_rank"
const world_size = 64
const duration = 80
const show_objects = true



# === Main Function ===

function main()

	Logging.global_logger(OceananigansLogger())

	archinfo = Arch.main()
	MPI.Barrier(archinfo.comm)

	grid = Grid.main(archinfo, world_size, show_objects)
	MPI.Barrier(archinfo.comm)

	model = Model.main(archinfo, grid, show_objects)
	MPI.Barrier(archinfo.comm)

	filename = string(filepath, archinfo.rank, ".nc")

	simulation = Sim.main(archinfo, model, duration, filename, show_objects)
	MPI.Barrier(archinfo.comm)

	run!(simulation)
	MPI.Barrier(archinfo.comm)

end


end # module

println("Starting the simulation\n")

MainSim.main()
