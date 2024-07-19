

module Grid


# === Importing libraries ===

using Oceananigans



# === Main Function ===

function main(world_size, show_grid = false)

	@info "Building grid..."

	Nx = Ny = Nz = world_size
	Lx = Ly = Lz = 128

	grid = RectilinearGrid(
		GPU();
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
