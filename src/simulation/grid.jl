

module Grid


# === Importing libraries ===

using Oceananigans



# === Main Function ===

function main(archinfo, world_size, show_grid = false)

	if archinfo.rank == 0
		@info "Building $(archinfo.Nranks) grids..."
	end

	Nx = Ny = Nz = world_size

	grid = RectilinearGrid(
		archinfo.arch;
		halo=(3, 3, 3),
		topology = (Periodic, Periodic, Bounded),
		size = (Nx, Ny, Nz),
		x = (0, 128),
		y = (0, 128),
		z = (-128, 0)
	)

	if show_grid
		@show grid
	end

	return grid

end


end # module
