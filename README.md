# Interfacial Solvation as an Information Channel

This repository contains NAMD simulation input files, Tcl scripts for analysis, and Julia scripts for figure generation associated with the manuscript:

**M. Oh and C. Oh, "Interfacial Solvation as an Information Channel: An Information-Theoretical Framework for Surface Charge Inference."**

The study investigates how information about the sign of surface charge is encoded in the orientational response of interfacial solvent molecules. Positively and negatively charged graphene surfaces were simulated in six solvents, and the interfacial solvent response was analyzed using a binary asymmetric channel, mutual information, information retention, and Bayesian maximum a posteriori decoding.

## Repository Structure

### `01_simulation_inputs/`

This directory contains representative NAMD simulation input files for the graphene-water systems used in the study.

The `H2O/` directory contains input structures for six surface charge densities:

- `neg020`: -0.20 C/m²
- `neg010`: -0.10 C/m²
- `neg005`: -0.05 C/m²
- `pos005`: +0.05 C/m²
- `pos010`: +0.10 C/m²
- `pos020`: +0.20 C/m²

Each charge state directory contains the relevant structure, topology, constraint, and restart files used for production simulations.

The `toppar/` directory contains the parameter files required for the NAMD simulations, and `eq_production.conf` contains the NAMD configuration used for production simulations.

Because of repository size limitations, the complete simulation input sets and trajectories for all solvent systems are not included here. The graphene-water systems are provided as representative examples of the simulation setup used throughout the study.

### `02_analysis_scripts/`

This directory contains representative Tcl analysis scripts for the water systems:

- `analysis_number_density_water.tcl`  
  Calculates solvent number density profiles as a function of distance from the graphene surface.

- `analysis_interfacial_orientation_distribution_water.tcl`  
  Calculates the conditional orientational distribution of interfacial water molecules.

- `analysis_interfacial_dipole_moment_water.tcl`  
  Calculates molecular dipole moments of interfacial water molecules.

- `analysis_MAP_decoding_water.tcl`  
  Performs maximum a posteriori (MAP) decoding of the surface charge sign from collective solvent orientations.

- `summary_orientation_water.xlsx`  
  Contains processed orientational data used in the analysis of the water systems.

The corresponding analyses for the other solvents followed the same workflow, with solvent-specific atom selections and molecular definitions.

### `03_figure_scripts/`

This directory contains Julia scripts used to generate the figures reported in the manuscript and Supporting Information:

- `draw_figure2.jl`
- `draw_figure3.jl`
- `draw_figure4.jl`
- `draw_figure5.jl`
- `draw_figureS1_S6.jl`
- `draw_figureS7_S8.jl`

These scripts reproduce the plotting and visualization procedures used for the corresponding figures from the processed numerical data.

## Note

* The complete molecular dynamics trajectories are not included in this repository because of their large file sizes.

* Similarly, the complete simulation input and trajectory data sets for all six solvents are not archived here. Representative simulation inputs and analysis scripts are provided to document the computational workflow used in the study.

* Mutual information and information retention calculations were performed using Excel spreadsheet-based calculations from the processed orientational probability distributions. The corresponding numerical values reported in the manuscript are used by the Julia scripts to generate figures.

## Software

* Molecular dynamics simulations were performed using NAMD 2.14 with the CHARMM36m force field.

* Trajectory analysis was performed primarily using Tcl scripts in VMD 1.9.3. Figure generation was performed using Julia.

## Contact

**Myongin Oh**  
Department of Chemistry  
Memorial University of Newfoundland  
St. John's, Newfoundland and Labrador, Canada  

Email: myongino@mun.ca
