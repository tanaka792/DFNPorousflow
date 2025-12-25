These input files use the same temperature variable and pore-pressure variable for both the fracture (DFN) and the matrix blocks.
DFN thermo-hydraulic modeling with aperture effects
Fracture aperture is represented by multiplying the porosity by the aperture. With this formulation, HM (hydro-mechanical) / TH (thermal-hydraulic) calculations were performed using the following settings:
Multiply the permeability by the aperture
Set the rock density or rock specific heat to 0
Set the rock thermal conductivity to 0, and use PorousFlowThermalConductivityFromPorosity
File descriptions
07_bench2forgit.i: DFN-only fluid flow calculation using dummy variables for the matrix (recommended).
07_bench1forgit.i (not recommended): a case where the matrix also has the temperature variable, but it produces an unphysical / unexplained temperature increase, so I do not recommend using it.
(If this is a different filename, please replace it accordingly.)

Boundary naming
Fracture boundaries:
high pressure / high temperature side: 5
opposite side: 6
Matrix boundaries:
high pressure / high temperature side: left2
opposite side: right2
