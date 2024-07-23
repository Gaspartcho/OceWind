

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

	t_grid = @elapsed grid = Grid.main(world_size, show_objects)

	t_model = @elapsed model = Model.main(grid, show_objects)

	#filename = string(filepath, archinfo.rank, ".nc")
	filename = string(filepath, trunc(Int, 100000*rand()), ".nc") #so I can run multiple in parallell

	t_csim = @elapsed simulation = Sim.main(model, duration, filename, show_objects)

	run!(simulation)

	io = open(time_result_path, "a")
	time_data = [world_size, duration, t_grid, t_model, t_csim, simulation.run_wall_time, iteration(simulation)]
	write(io, join(map(string, time_data), "\t"))
	write(io, "\n")
	close(io)

end


end # module

println("Starting the simulation\n")

MainSim.main()
