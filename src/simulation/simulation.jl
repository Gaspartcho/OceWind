

module Sim


# === Importing libraries ===

using Oceananigans
using Oceananigans.Units: minute, minutes, hour
using Printf



# === Main Function ===

function main(model, duration, filename, show_sim = false)

	@info "Building simulation ..."

	simulation = Simulation(model, Δt=10.0, stop_time=duration * minutes)

	# Time wizard

	wizard = TimeStepWizard(cfl=1.0, max_change=1.1, max_Δt=1minute)
	simulation.callbacks[:wizard] = Callback(wizard, IterationInterval(10))


	function progress(sim)

		@info string(
			"Iteration: ",
			iteration(sim),
			", time: ",
			prettytime(sim),
			", Δt: ",
			prettytime(sim.Δt)
		)


		@info @sprintf(
			"max(|w|) = %.1e ms⁻¹, wall time: %s",
			maximum(abs, sim.model.velocities.w),
			prettytime(sim.run_wall_time)
		)

		return nothing

	end

	add_callback!(simulation, progress, IterationInterval(50))


	# Create a NamedTuple with eddy viscosity

	u, v, w = model.velocities
	T = model.tracers.T
	P = model.pressures.pNHS

	outputs = Dict(
		"u" => u,
		"v" => v,
		"w" => w,
		"T" => T,
		"P" => P,
	)

	simulation.output_writers[:field_writer] = NetCDFOutputWriter(
		model,
		outputs,
		schedule = TimeInterval(1minute),
		filename = filename,
		overwrite_existing = true
	)


	if show_sim
		@show simulation
	end


	return simulation


end


end # module
