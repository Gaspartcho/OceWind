

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
const world_size = 32
const duration = 60
const show_objects = false
const time_result_path = "results/logs/time.txt"


# === Main Function ===

function main()

	Logging.global_logger(OceananigansLogger())

	t_MPI = @elapsed archinfo = Arch.main()
	MPI.Barrier(archinfo.comm)

	t_grid = @elapsed grid = Grid.main(archinfo, world_size, show_objects)
	MPI.Barrier(archinfo.comm)

	t_model = @elapsed model = Model.main(archinfo, grid, show_objects)
	MPI.Barrier(archinfo.comm)

	#filename = string(filepath, archinfo.rank, ".nc")
	filename = string(filepath, trunc(Int, 1000*rand()), ".nc") #so I can run multiple in parallell

	t_csim = @elapsed simulation = Sim.main(archinfo, model, duration, filename, show_objects)
	MPI.Barrier(archinfo.comm)

	t_rsim = @elapsed run!(simulation)
	MPI.Barrier(archinfo.comm)

	if archinfo.rank == 0
		io = open(time_result_path, "a")
		time_data = [archinfo.Nranks, world_size, duration, t_MPI, t_grid, t_model, t_csim, t_rsim]
		write(io, join(map(string, time_data), "\t"))
		write(io, "\n")
		close(io)
	end

end


end # module

println("Starting the simulation\n")

MainSim.main()
