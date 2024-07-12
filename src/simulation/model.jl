

module Model


# === Importing libraries ===

using Oceananigans
using Oceananigans.Units: hour



# === Main Function ===

function main(archinfo, grid, show_model = false)

	if archinfo.rank == 0
		@info "Building $(archinfo.Nranks) models ..."
	end
	
	
	# Buoyancy

	buoyancy = SeawaterBuoyancy(equation_of_state=LinearEquationOfState(thermal_expansion = 2e-4, haline_contraction = 8e-4))


	# Boundary Conditions

	# Surface temperature flux

	Qʰ = 200.0  # W m⁻², surface _heat_ flux
	ρₒ = 1026.0 # kg m⁻³, average density at the surface of the world ocean
	cᴾ = 3991.0 # J K⁻¹ kg⁻¹, typical heat capacity for seawater

	Qᵀ = Qʰ / (ρₒ * cᴾ) # K m s⁻¹, surface _temperature_ flux


	# Temperature gradient

	dTdz = 0.01 # K m⁻¹

	T_bcs = FieldBoundaryConditions(top = FluxBoundaryCondition(Qᵀ), bottom = GradientBoundaryCondition(dTdz))


	# Velocity field

	u₁₀ = 10    # m s⁻¹, average wind velocity 10 meters above the ocean
	cᴰ = 2.5e-3 # dimensionless drag coefficient
	ρₐ = 1.225  # kg m⁻³, average density of air at sea-level

	Qᵘ = - ρₐ / ρₒ * cᴰ * u₁₀ * abs(u₁₀) # m² s⁻²

	u_bcs = FieldBoundaryConditions(top = FluxBoundaryCondition(Qᵘ))


	# Salinity

	@inline Qˢ(_, _, _, S, evaporation_rate) = - evaporation_rate * S # [salinity unit] m s⁻¹

	evaporation_rate = 1e-3 / hour # m s⁻¹

	evaporation_bc = FluxBoundaryCondition(Qˢ, field_dependencies=:S, parameters=evaporation_rate)

	S_bcs = FieldBoundaryConditions(top=evaporation_bc)


	# Model instantiation

	model = NonhydrostaticModel(
		;
		grid,
		buoyancy,
		advection = UpwindBiasedFifthOrder(),
		timestepper = :RungeKutta3,
		tracers = (:T, :S),
		coriolis = FPlane(f=1e-4),
		closure = AnisotropicMinimumDissipation(),
		boundary_conditions = (u=u_bcs, T=T_bcs, S=S_bcs)
	)
	
	
	if show_model
		@show model
	end
	
	
	# == Initial Conditions ==
	
	# Random noise damped at top and bottom
	Ξ(z) = randn() * z / model.grid.Lz * (1 + z / model.grid.Lz) # noise

	# Temperature initial condition: a stable density gradient with random noise superposed.
	Tᵢ(_, _, z) = 20 + dTdz * z + dTdz * model.grid.Lz * 1e-6 * Ξ(z)

	# Velocity initial condition: random noise scaled by the friction velocity.
	uᵢ(_, _, z) = sqrt(abs(Qᵘ)) * 1e-3 * Ξ(z)

	# `set!` the `model` fields using functions or constants:
	set!(model, u=uᵢ, w=uᵢ, T=Tᵢ, S=35)
	
	
	return model
	
end


end # module
