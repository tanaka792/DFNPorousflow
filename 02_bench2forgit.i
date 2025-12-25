[Mesh]
  [gen]
    type = FileMeshGenerator
    file = 07_mesh_create_in.e
    allow_renumbering = false
    skip_partitioning = true
  []
      construct_side_list_from_node_list=true
[]
[GlobalParams]
  PorousFlowDictator = dictator
  gravity = '0 0 0'
      block = frac
[]

[Variables]
 [dummy_T]
 block = box
     initial_condition = 500
         scaling = 1e-2
 []
  [pwater]
      block = frac
      initial_condition = 0
  []
  [temperature]
    initial_condition = 273
    block = frac
  []
[]

[Kernels] 
  [advection]
    type = PorousFlowFullySaturatedDarcyBase
    variable = pwater
    use_displaced_mesh = false
    block = 'frac'
  []
  [energy_dot]
    type = PorousFlowEnergyTimeDerivative
    variable = temperature
    block = 'frac'
  []
 [heat_conduction]
   type = PorousFlowHeatConduction
    variable = temperature
    block = 'frac'
     []
  
  [convection]
   type = PorousFlowHeatAdvection
   variable = temperature
   full_upwind_threshold = 5
   block = 'frac' 
      []


  [dot_matrix_T]
    type = TimeDerivative
    variable = dummy_T
    block = box
  []
  [matrix_diffusion]
    type = AnisotropicDiffusion
    variable = dummy_T
    tensor_coeff = '1E-3 0 0 0 1E-3 0 0 0 1E-3'
    block = box
  []
[]

[AuxVariables]
  [massfrac_ph0_sp0]
    initial_condition = 1 # all H20 in phase=0
  []
  [velocity_x]
    family = MONOMIAL
    order = CONSTANT
  []
  [velocity_y]
    family = MONOMIAL
    order = CONSTANT
  []
  [velocity_z]
    family = MONOMIAL
    order = CONSTANT
  []
    [lambda_x]
    order = CONSTANT
    family = MONOMIAL
  []
  [lambda_y]
    order = CONSTANT
    family = MONOMIAL
  []
  [lambda_z]
    order = CONSTANT
    family = MONOMIAL
  []
  [rho_f]
    order = FIRST
    family = MONOMIAL
  []
[]

[AuxKernels]
  [velocity_x]
    type = PorousFlowDarcyVelocityComponent
    variable = velocity_x
    component = x
  []
  [velocity_y]
    type = PorousFlowDarcyVelocityComponent
    variable = velocity_y
    component = y
  []
  [velocity_z]
    type = PorousFlowDarcyVelocityComponent
    variable = velocity_z
    component = z
  []
  [rho_f]
    type = PorousFlowPropertyAux
    variable = rho_f
    property = density
    phase = 0
  []
   [lambda_x]
    type = MaterialRealTensorValueAux
    property = PorousFlow_thermal_conductivity_qp
    row = 0
    column = 0
    variable = lambda_x
  []
  [lambda_y]
    type = MaterialRealTensorValueAux
    property = PorousFlow_thermal_conductivity_qp
    row = 1
    column = 1
    variable = lambda_y
  []
  [lambda_z]
    type = MaterialRealTensorValueAux
    property = PorousFlow_thermal_conductivity_qp
    row = 2
    column = 2
    variable = lambda_z
  []
[]

[UserObjects]
  [dictator]
    type = PorousFlowDictator
    porous_flow_vars = 'pwater temperature'
    number_fluid_phases = 1
    number_fluid_components = 1
 #   block = 'frac'   
  []
[]

[FluidProperties]
  [water]
    type = SimpleFluidProperties
    bulk_modulus = 2.2e9
    density0 = 1000
    viscosity = 1e-13
    cv = 20
    thermal_expansion = 0
    porepressure_coefficient = 0
  []
[]

[ICs]
  [pp]
    type = FunctionIC
    variable = pwater
    function = '10000-200*x'
  []
[]

[BCs]
   [inlet_p]
    type = DirichletBC
    boundary = 5
    variable = pwater
    value = 20000
  []
  [pp1]
    type = DirichletBC
    variable = pwater
    boundary = 6
    value = 0      
    []
 
  [spit_heat]
    type = DirichletBC
    variable = temperature
    boundary = 5
    value = 373
  []
  [spit_heat2]
    type = DirichletBC
    variable = temperature
    boundary = 6
    value = 273
  []
[]

[Materials]
  [temperature]
    type = PorousFlowTemperature
    temperature = temperature
        block = 'frac'
  []
  [massfrac]
    type = PorousFlowMassFraction
  []
# 岩盤（box）のみ
    [rock_heats]
    type = PorousFlowMatrixInternalEnergy
    specific_heat_capacity = 0
    density = 1700
  []
  # フラクチャ（frac）だけ流体を入れる
  [porosity_frac]
    type = PorousFlowPorosityConst
    porosity = 0.0001
  []
  [simple_fluid]
    type = PorousFlowSingleComponentFluid
    fp = water
    phase = 0
 #   block = 'box'
  []
  [PS]
    type = PorousFlow1PhaseFullySaturated
    porepressure = pwater
 #   block = 'frac'
  []
  [relperm]
    type = PorousFlowRelativePermeabilityConst
    phase = 0
 #   block = 'frac'
  []
  [permeability_frac] #2.4mm
    type = PorousFlowPermeabilityConst
    permeability = '1.04e-19 0 0   0 1.04e-19 0   0 0 1.04e-19'

  []
  [lambda_frac]
    type = PorousFlowThermalConductivityFromPorosity
    lambda_s = '0 0 0  0 0 0  0 0 0'
    lambda_f = '3 0 0  0 3 0  0 0 3'
  []
  [dummy_M]
   type = GenericConstantArray
    prop_name = dummy
    prop_value = '1 1'
    block = 'box'
  []
[]

[Preconditioning]
  active = basic
  [basic]
    type = SMP
    full = true
    petsc_options = '-ksp_diagonal_scale -ksp_diagonal_scale_fix'
    petsc_options_iname = '-pc_type -sub_pc_type -sub_pc_factor_shift_type -pc_asm_overlap'
    petsc_options_value = ' asm      lu           NONZERO                   2'
  []
  [preferred_but_might_not_be_installed]
    type = SMP
    full = true
    petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
    petsc_options_value = ' lu       mumps'
  []
[]

#[Executioner]
#  type = Steady
#  solve_type = NEWTON

#  nl_rel_tol = 1e-12
#  nl_abs_tol = 1e-14  # 時間関係のパラメータ(dt, dtmin, dtmax, end_timeなど)は全部不要    []

[Executioner]
  type = Transient
  solve_type = NEWTON
  end_time = 300
  compute_scaling_once = false
   [TimeStepper]
    type = IterationAdaptiveDT
    #optimal_iterations = 10
    growth_factor = 2
    #linear_iteration_ratio = 20 #
    dt = 0.01
    []
  dtmax = 0.1
  dtmin=1e-8
  nl_rel_tol = 1e-7
  nl_abs_tol = 1e-9
  nl_forced_its = 1
  #automatic_scaling = true 
[]




[Outputs]
[exodus_all_time]
  type = Exodus
  file_base = result_time_step
[]
[]
[Debug]
  show_var_residual_norms = true
[]
