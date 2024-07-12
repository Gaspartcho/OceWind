

module Grid


# === Importing libraries ===

using Oceananigans



# === Main Function ===

function main(archinfo, world_size, show_grid = false)

	if archinfo.rank == 0
		@info "Building $(archinfo.Nranks) grids..."
	end

	Nx = Ny = Nz = world_size
	Lx = Ly = 2Nx
	Lz = Nx
	
	grid = RectilinearGrid(
		archinfo.arch;
		halo=(3, 3, 3),
		topology = (Periodic, Periodic, Bounded),
		size = (Nx, Ny, Nz),
		x = (0, Lx),
		y = (0, Ly),
		z = (-Lz, 0)
	)
	
	if show_grid
		@show grid
	end
	
	return grid

end


end # module
