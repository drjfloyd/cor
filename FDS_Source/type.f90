MODULE TYPES

! Definitions of various derived data types
 
USE PRECISION_PARAMETERS

IMPLICIT NONE
CHARACTER(255), PARAMETER :: typeid='$Id$'
CHARACTER(255), PARAMETER :: typerev='$Revision$'
CHARACTER(255), PARAMETER :: typedate='$Date$'

TYPE PARTICLE_CLASS_TYPE
   CHARACTER(30) :: ID,SPEC_ID,DEVC_ID='null',CTRL_ID='null',QUANTITIES(10),SMOKEVIEW_BAR_LABEL(10),SURF_ID='null'
   CHARACTER(60) :: SMOKEVIEW_LABEL(10),SMOKEVIEW_ID=' '
   REAL(EB) :: DENSITY,TMP_V,TMP_MELT,FTPR,MASS_PER_VOLUME,MASS_PER_TIME, &
               HEAT_OF_COMBUSTION,ADJUST_EVAPORATION, &
               LIFETIME,AZIMUTH,ELEVATION,DIAMETER,MINIMUM_DIAMETER,MAXIMUM_DIAMETER,GAMMA,KILL_RADIUS, &
               TMP_INITIAL,SIGMA,X1,X2,Y1,Y2,Z1,Z2,DT_INSERT,GAMMA_VAP,&
               VERTICAL_VELOCITY,HORIZONTAL_VELOCITY, &
               VEG_SV,VEG_MOISTURE,VEG_CHAR_FRACTION,VEG_DRAG_COEFFICIENT,VEG_BULK_DENSITY, &
               VEG_DENSITY,VEG_BURNING_RATE_MAX,VEG_DEHYDRATION_RATE_MAX,VEG_INITIAL_TEMPERATURE, &
               VEG_FUEL_MPV_MIN,VEG_MOIST_MPV_MIN,USER_DRAG_COEFFICIENT, &
               SURFACE_TENSION,BREAKUP_CHILD_DIAMETER,BREAKUP_CHILD_GAMMA,BREAKUP_CHILD_SIGMA
   REAL(EB), POINTER, DIMENSION(:) :: R_CDF,CDF,CHILD_R_CDF,CHILD_CDF,W_CDF,INSERT_CLOCK,KWR
   REAL(EB), POINTER, DIMENSION(:,:) :: WQABS,WQSCA
   REAL(EB) :: H_V(5000)=-1._EB,C_P(5000)=-1._EB,C_P_BAR(5000)=-1._EB,H_L(5000), &
               H_V_REFERENCE_TEMPERATURE,H_V_CORRECTOR=0._EB
   INTEGER :: NUMBER_INITIAL_DROPLETS,SAMPLING,N_INSERT,SPEC_INDEX,N_QUANTITIES,QUANTITIES_INDEX(10),EVAP_INDEX=0,RGB(3), &
              SURF_INDEX=-1,WALL_INDEX_START=-1,DRAG_LAW=1,DEVC_INDEX=0,CTRL_INDEX=0
   INTEGER,  POINTER, DIMENSION(:) :: IL_CDF,IU_CDF
   LOGICAL :: STATIC=.FALSE.,WATER=.FALSE.,FUEL=.FALSE.,MASSLESS,TREE=.FALSE.,MONODISPERSE=.FALSE.,EVAPORATE=.TRUE., &
              RADIATION=.TRUE.,BREAKUP=.FALSE.
   LOGICAL VEG_REMOVE_CHARRED,VEG_STEM
END TYPE PARTICLE_CLASS_TYPE

TYPE (PARTICLE_CLASS_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: PARTICLE_CLASS

TYPE DROPLET_TYPE
   REAL(EB) :: X,Y,Z,TMP,U,V,W,R,PWT,A_X,A_Y,A_Z,T,RE=0._EB, &
               VEG_KAPPA,VEG_EMISS,VEG_DIVQR,VEG_PACKING_RATIO,VEG_FUEL_MASS,VEG_MOIST_MASS,VEG_IGN_TON,VEG_IGN_TOFF,&
               VEG_IGN_TRAMPON,VEG_IGN_TRAMPOFF
   LOGICAL  :: IGNITOR
   INTEGER  :: IOR,CLASS,TAG,WALL_INDEX=0,VEG_N_TREE_OUTPUT
   LOGICAL  :: SHOW,SPLAT=.FALSE.
END TYPE DROPLET_TYPE

TYPE WALL_TYPE
   REAL(EB), POINTER, DIMENSION(:) :: TMP_S, LAYER_THICKNESS,X_S
   REAL(EB), POINTER, DIMENSION(:,:) :: ILW,RHO_S
   INTEGER, POINTER, DIMENSION(:) :: N_LAYER_CELLS
   LOGICAL :: SHRINKING, BURNAWAY,ALREADY_ALLOCATED=.FALSE.
END TYPE WALL_TYPE
 
TYPE SPECIES_TYPE
   REAL(EB) :: MW,YY0,RCON,MAXMASS,MASS_EXTINCTION_COEFFICIENT,D(5000),SPECIFIC_HEAT=-1._EB,SPECIFIC_ENTHALPY=-1._EB,&
               REFERENCE_TEMPERATURE
   LOGICAL :: ABSORBING,ISFUEL=.FALSE.
   CHARACTER(30):: ID,FORMULA
   INTEGER :: MODE,INDEX
END TYPE SPECIES_TYPE

TYPE (SPECIES_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: SPECIES

TYPE REACTION_TYPE
   CHARACTER(30) :: FUEL,OXIDIZER,NAME
   REAL(EB) :: EPUMO2,HEAT_OF_COMBUSTION,BOF,E,N_F=0._EB,N_O=0._EB, &
      Y_O2_INFTY,Y_N2_INLET=0._EB,Y_N2_INFTY=0._EB,Y_F_INLET=1._EB,MW_FUEL,MW_OTHER, &
      CO_YIELD,SOOT_YIELD,H2_YIELD, SOOT_H_FRACTION, &
      CRIT_FLAME_TMP,Y_F_LFL,Y_O2_LL,O2_F_RATIO=0._EB,Z_F=0._EB,Z_F_CONS=0._EB,AIT=0._EB
   REAL(EB) :: COLLISION_EXPONENT=1._EB
   REAL(EB), DIMENSION(:), POINTER :: NU,N
   INTEGER :: I_FUEL=0,I_OXIDIZER=0,MODE,N_COLLISION_SPECIES=0,N_SPECIES=0
   INTEGER, DIMENSION(:), POINTER :: COLLISION_SPECIES,SPECIES
   LOGICAL :: IDEAL,COLLISION=.FALSE.
   CHARACTER(100) :: FYI='null'
END TYPE REACTION_TYPE

TYPE (REACTION_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: REACTION

TYPE REAC_SPECIES_TYPE
   INTEGER :: N_REACTIONS,SPEC_INDEX
   INTEGER, DIMENSION(:,:), POINTER :: REACTION_POINTER
END TYPE REAC_SPECIES_TYPE

TYPE (REAC_SPECIES_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: REAC_SPECIES
 
TYPE MATERIAL_TYPE
   REAL(EB) :: K_S,C_S,RHO_S,EMISSIVITY,DIFFUSIVITY,KAPPA_S,MOISTURE_FRACTION,TMP_BOIL,INIT_VAPOR_FLUX
   INTEGER :: PYROLYSIS_MODEL
   CHARACTER(30) :: RAMP_K_S,RAMP_C_S
   INTEGER :: N_REACTIONS,PROP_INDEX=-1,CABL_INDEX=-1
   INTEGER, DIMENSION(1:MAX_REACTIONS) :: RESIDUE_MATL_INDEX
   REAL(EB), DIMENSION(1:MAX_REACTIONS) :: TMP_REF,TMP_IGN,TMP_THR
   REAL(EB), DIMENSION(1:MAX_REACTIONS) :: NU_RESIDUE,NU_FUEL,NU_WATER,A,E,H_R,N_S,N_T,HEATING_RATE,PYROLYSIS_RANGE
   REAL(EB), DIMENSION(1:MAX_REACTIONS,1:MAX_SPECIES) :: NU_GAS,HEAT_OF_COMBUSTION,ADJUST_BURN_RATE
   CHARACTER(30), DIMENSION(1:MAX_REACTIONS) :: RESIDUE_MATL_NAME
   CHARACTER(100) :: FYI='null'
   LOGICAL :: USER_DEFINED=.TRUE.,CONDUIT=.FALSE.,AIR=.FALSE.
END TYPE MATERIAL_TYPE

TYPE (MATERIAL_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: MATERIAL

TYPE SURFACE_TYPE
   REAL(EB) :: TMP_FRONT,TMP_INNER,VEL,PLE,Z0,CONVECTIVE_HEAT_FLUX, NET_HEAT_FLUX, &
               VOLUME_FLUX,HRRPUA,MLRPUA,T_IGN,SURFACE_DENSITY,CELL_SIZE_FACTOR, &
               E_COEFFICIENT,TEXTURE_WIDTH,TEXTURE_HEIGHT,THICKNESS,EXTERNAL_FLUX,TMP_BACK, &
               DXF,DXB,MASS_FLUX_TOTAL,STRETCH_FACTOR,PARTICLE_MASS_FLUX,EMISSIVITY,MAX_PRESSURE,&
               TMP_IGN,H_V,REGRID_FACTOR,LAYER_DIVIDE,ROUGHNESS,RADIUS=-1._EB,LENGTH=-1._EB,WIDTH=-1._EB
   REAL(EB), POINTER, DIMENSION(:) :: DX,RDX,RDXN,X_S,DX_WGT,MF_FRAC
   REAL(EB), DIMENSION(0:MAX_SPECIES) :: MASS_FRACTION,MASS_FLUX
   REAL(EB), DIMENSION(-4:MAX_SPECIES) :: TAU
   INTEGER,  DIMENSION(-4:MAX_SPECIES) :: RAMP_INDEX=0
   INTEGER, DIMENSION(3) :: RGB
   REAL(EB) :: TRANSPARENCY
   REAL(EB), DIMENSION(2) :: VEL_T
   INTEGER, DIMENSION(2) :: LEAK_PATH,DUCT_PATH
   INTEGER :: THERMAL_BC_INDEX,NPPC,SPECIES_BC_INDEX,VELOCITY_BC_INDEX,SURF_TYPE,N_CELLS,PART_INDEX,PROP_INDEX=-1,CABL_INDEX=-1
   INTEGER :: PYROLYSIS_MODEL
   INTEGER :: N_LAYERS,N_MATL
   INTEGER, POINTER, DIMENSION(:) :: N_LAYER_CELLS,LAYER_INDEX,MATL_INDEX
   INTEGER, DIMENSION(MAX_LAYERS,MAX_MATERIALS) :: LAYER_MATL_INDEX
   INTEGER, DIMENSION(MAX_LAYERS) :: N_LAYER_MATL
   INTEGER, POINTER, DIMENSION(:,:) :: RESIDUE_INDEX
   REAL(EB), POINTER, DIMENSION(:) :: MIN_DIFFUSIVITY
   REAL(EB), DIMENSION(MAX_LAYERS) :: LAYER_THICKNESS, LAYER_DENSITY
   CHARACTER(30), POINTER, DIMENSION(:) :: MATL_NAME
   CHARACTER(30), DIMENSION(MAX_LAYERS,MAX_MATERIALS) :: LAYER_MATL_NAME
   REAL(EB), DIMENSION(MAX_LAYERS,MAX_MATERIALS) :: LAYER_MATL_FRAC
   LOGICAL :: BURN_AWAY,ADIABATIC,THERMALLY_THICK,INTERNAL_RADIATION,SHRINK,POROUS=.FALSE.,USER_DEFINED=.TRUE., &
              FREE_SLIP=.FALSE.,NO_SLIP=.FALSE.,SPECIFIED_NORMAL_VELOCITY=.FALSE.,SPECIFIED_TANGENTIAL_VELOCITY=.FALSE.
   INTEGER :: GEOMETRY,BACKING,PROFILE
   CHARACTER(30) :: PART_ID,RAMP_Q,RAMP_V,RAMP_T,RAMP_EF
   CHARACTER(30), DIMENSION(0:MAX_SPECIES) :: RAMP_MF
   CHARACTER(60) :: ID,TEXTURE_MAP
   CHARACTER(100) :: FYI='null'
END TYPE SURFACE_TYPE

TYPE (SURFACE_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: SURFACE

TYPE OMESH_TYPE
   REAL(EB), POINTER, DIMENSION(:,:,:) :: MU,RHO,RHOS,U,V,W,US,VS,WS,H,DUDT,DVDT,DWDT,D,DS
   REAL(EB), POINTER, DIMENSION(:,:,:,:) :: YY,YYS
   INTEGER, POINTER, DIMENSION(:,:) :: IJKW
   INTEGER, POINTER, DIMENSION(:) :: BOUNDARY_TYPE
   TYPE(WALL_TYPE), POINTER, DIMENSION(:) :: WALL
   TYPE(DROPLET_TYPE), POINTER, DIMENSION(:) :: DROPLET
   INTEGER :: N_DROP_ORPHANS,N_DROP_ORPHANS_DIM,N_DROP_ADOPT
   REAL(EB), POINTER, DIMENSION(:) :: &
         REAL_SEND_PKG1,REAL_SEND_PKG2,REAL_SEND_PKG3,REAL_SEND_PKG4,REAL_SEND_PKG5,REAL_SEND_PKG6,REAL_SEND_PKG7, &
         REAL_RECV_PKG1,REAL_RECV_PKG2,REAL_RECV_PKG3,REAL_RECV_PKG4,REAL_RECV_PKG5,REAL_RECV_PKG6,REAL_RECV_PKG7
   INTEGER , POINTER, DIMENSION(:) :: INTG_SEND_PKG1,INTG_RECV_PKG1
   LOGICAL , POINTER, DIMENSION(:) :: LOGI_SEND_PKG1,LOGI_RECV_PKG1
END TYPE OMESH_TYPE
 
TYPE OBSTRUCTION_TYPE
   CHARACTER(30) :: DEVC_ID='null',CTRL_ID='null'
   INTEGER, DIMENSION(-3:3) :: IBC=0
   LOGICAL, DIMENSION(-3:3) :: SHOW_BNDF=.TRUE.
   INTEGER, DIMENSION(3) :: RGB=(/0,0,0/)
   INTEGER, DIMENSION(3) :: DIMENSIONS=0
   REAL(EB) :: TRANSPARENCY=1._EB,BULK_DENSITY=-1._EB,VOLUME_ADJUST=1._EB
   REAL(EB), DIMENSION(3) :: TEXTURE=0._EB
   REAL(EB) :: X1=0._EB,X2=1._EB,Y1=0._EB,Y2=1._EB,Z1=0._EB,Z2=1._EB,T_REMOVE=1.E6_EB,MASS=1.E6_EB
   REAL(EB), DIMENSION(3) :: FDS_AREA=-1._EB,INPUT_AREA=-1._EB
   INTEGER :: I1=-1,I2=-1,J1=-1,J2=-1,K1=-1,K2=-1,COLOR_INDICATOR=-1,TYPE_INDICATOR=-1,ORDINAL=0,DEVC_INDEX=-1,CTRL_INDEX=-1
   LOGICAL :: SAWTOOTH=.TRUE.,HIDDEN=.FALSE.,PERMIT_HOLE=.TRUE.,ALLOW_VENT=.TRUE.,CONSUMABLE=.FALSE.,REMOVABLE=.FALSE., &
              THIN=.FALSE.,HOLE_FILLER=.FALSE.
END TYPE OBSTRUCTION_TYPE

TYPE GEOMETRY_TYPE
   CHARACTER(30) :: SHAPE='BOX',SURF_ID='null'
   REAL(EB) :: X1=0._EB,X2=0._EB,Y1=0._EB,Y2=0._EB,Z1=0._EB,Z2=0._EB
   REAL(EB) :: X0=0._EB,Y0=0._EB,Z0=0._EB,X=0._EB,Y=0._EB,Z=0._EB,XOR=0._EB,YOR=0._EB,ZOR=0._EB
   REAL(EB) :: RADIUS=1.E6_EB
   REAL(EB) :: U0=0._EB,V0=0._EB,W0=0._EB,U=0._EB,V=0._EB,W=0._EB
   REAL(EB) :: OMEGA_X=0._EB,OMEGA_Y=0._EB,OMEGA_Z=0._EB
   LOGICAL :: TRANSLATE=.FALSE.,ROTATE=.FALSE.,HOLE=.FALSE.,TWO_SIDED=.FALSE.
   INTEGER :: ISHAPE
   INTEGER, POINTER, DIMENSION(:) :: MIN_I,MAX_I,MIN_J,MAX_J,MIN_K,MAX_K
   INTEGER, POINTER, DIMENSION(:,:,:) :: U_MASK,V_MASK,W_MASK
   INTEGER, DIMENSION(3) :: RGB=(/192,192,192/)
   REAL(EB), DIMENSION(3) :: NN=(/0._EB,0._EB,0._EB/),HL=(/0.5_EB,0.5_EB,0.5_EB/)
   REAL(EB) :: PIXELS=1.0
END TYPE GEOMETRY_TYPE

TYPE(GEOMETRY_TYPE), POINTER, DIMENSION(:) :: GEOMETRY
 
TYPE VENTS_TYPE
   INTEGER :: I1=-1,I2=-1,J1=-1,J2=-1,K1=-1,K2=-1,BOUNDARY_TYPE=0,IOR=0,IBC=0,DEVC_INDEX=-1,CTRL_INDEX=-1, &
              COLOR_INDICATOR=99,TYPE_INDICATOR=0,ORDINAL=0,PRESSURE_RAMP_INDEX=0,NODE_INDEX=-1
   INTEGER, DIMENSION(3) :: RGB=-1
   REAL(EB) :: TRANSPARENCY = 1._EB
   REAL(EB), DIMENSION(3) :: TEXTURE=0._EB
   REAL(EB) :: X1=0._EB,X2=0._EB,Y1=0._EB,Y2=0._EB,Z1=0._EB,Z2=0._EB,FDS_AREA=0._EB,TOTAL_INPUT_AREA=0._EB, &
               X0=-9.E6_EB,Y0=-9.E6_EB,Z0=-9.E6_EB,FIRE_SPREAD_RATE=0.05_EB,INPUT_AREA=0._EB,TMP_EXTERIOR=-1000._EB, &
               MASS_FRACTION(MAX_SPECIES)=-1._EB,DYNAMIC_PRESSURE=0._EB
   LOGICAL :: ACTIVATED=.TRUE.
   CHARACTER(30) :: DEVC_ID='null',CTRL_ID='null',ID='null'
END TYPE VENTS_TYPE
 
TYPE TABLES_TYPE
   INTEGER :: NUMBER_ROWS,NUMBER_COLUMNS
   REAL(EB), POINTER, DIMENSION (:,:) :: TABLE_DATA
END TYPE TABLES_TYPE

TYPE (TABLES_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: TABLES
   
TYPE RAMPS_TYPE
   REAL(EB) :: SPAN,DT,T_MIN,T_MAX,VALUE
   REAL(EB), POINTER, DIMENSION(:) :: INDEPENDENT_DATA,DEPENDENT_DATA,INTERPOLATED_DATA
   INTEGER :: NUMBER_DATA_POINTS,NUMBER_INTERPOLATION_POINTS,DEVC_INDEX=-1,CTRL_INDEX=-1
   CHARACTER(30) :: DEVC_ID='null',CTRL_ID='null'
END TYPE RAMPS_TYPE

TYPE (RAMPS_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: RAMPS

TYPE HUMAN_TYPE
   CHARACTER(60) :: NODE_NAME='null'
   CHARACTER(30) :: FFIELD_NAME='null'
   REAL(EB) :: X=0._EB,Y=0._EB,Z=0._EB,U=0._EB,V=0._EB,W=0._EB,F_X=0._EB,F_Y=0._EB,&
               X_old=0._EB,Y_old=0._EB,X_group=0._EB,Y_group=0._EB
   REAL(EB) :: UBAR=0._EB, VBAR=0._EB, UBAR_Center=0._EB, VBAR_Center=0._EB
   REAL(EB) :: Speed=1.25_EB, Radius=0.255_EB, Mass=80.0_EB, Tpre=1._EB, Tau=1._EB, &
               Eta=0._EB, Ksi=0._EB, Tdet=0._EB
   REAL(EB) :: r_torso=0.15_EB, r_shoulder=0.095_EB, d_shoulder=0.055_EB, angle=0._EB, &
               torque=0._EB, m_iner=4._EB
   REAL(EB) :: tau_iner=0.2_EB, angle_old=0._EB, omega=0._EB
   REAL(EB) :: A=2000._EB, B=0.08_EB, C_Young=120000._EB, Gamma=16000._EB, Kappa=40000._EB, &
               Lambda=0.5_EB, Commitment=0._EB
   REAL(EB) :: SumForces=0._EB, IntDose=0._EB, DoseCrit1=0._EB, DoseCrit2=0._EB, SumForces2=0._EB
   REAL(EB) :: TempMax1=0._EB, FluxMax1=0._EB, TempMax2=0._EB, FluxMax2=0._EB
   REAL(EB) :: P_detect_tot=0._EB, v0_fac=1._EB
   INTEGER  :: IOR=-1, ILABEL=0, COLOR_INDEX=0, INODE=0, IMESH=-1, IPC=0, IEL=0, I_FFIELD=0
   INTEGER  :: GROUP_ID=0, DETECT1=0, GROUP_SIZE=0, I_Target=0, I_DoorAlgo=0, STRS_Direction = 1
   INTEGER  :: STR_SUB_INDX, SKIP_WALL_FORCE_IOR
   LOGICAL  :: SHOW=.TRUE., NewRnd=.TRUE.
END TYPE HUMAN_TYPE

TYPE HUMAN_GRID_TYPE
! (x,y,z) Centers of the grid cells in the main evacuation meshes
! SOOT_DENS: Smoke density at the center of the cell (mg/m3)
! FED_CO_CO2_O2: Purser's FED for co, co2, and o2
   REAL(EB) :: X,Y,Z,SOOT_DENS,FED_CO_CO2_O2,TMP_G,RADFLUX
   INTEGER :: N, N_old, IGRID, IHUMAN, ILABEL
! IMESH: (x,y,z) which fire mesh, if any
! II,JJ,KK: Fire mesh cell reference
   INTEGER  :: IMESH,II,JJ,KK
END TYPE HUMAN_GRID_TYPE
 
TYPE OUTPUT_QUANTITY_TYPE
   CHARACTER(30) :: NAME='null',SHORT_NAME='null',UNITS='null'
   REAL(EB) :: AMBIENT_VALUE=0._EB
   INTEGER :: IOR=0,CELL_POSITION=1
   LOGICAL :: SLCF_APPROPRIATE=.TRUE., BNDF_APPROPRIATE=.FALSE., ISOF_APPROPRIATE=.TRUE., PART_APPROPRIATE=.FALSE., &
              MIXTURE_FRACTION_ONLY=.FALSE.,INTEGRATED=.FALSE.,SOLID_PHASE=.FALSE.,GAS_PHASE=.TRUE.,INTEGRATED_DROPLETS=.FALSE., &
              MASS_FRACTION=.FALSE.,SPEC_ID_REQUIRED=.FALSE.,PART_ID_REQUIRED=.FALSE.,INSIDE_SOLID=.FALSE., &
              MATL_ID_REQUIRED=.FALSE.,TIME_AVERAGED=.TRUE.,DEVC_APPROPRIATE=.TRUE.,&
              DUCT_ID_REQUIRED=.FALSE.,NODE_ID_REQUIRED=.FALSE.,HVAC=.FALSE.
END TYPE OUTPUT_QUANTITY_TYPE

TYPE (OUTPUT_QUANTITY_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: OUTPUT_QUANTITY

TYPE SLICE_TYPE
   INTEGER :: I1,I2,J1,J2,K1,K2,INDEX,SPEC_INDEX=0,PART_INDEX=0,VELO_INDEX=0
   LOGICAL :: RLE
   REAL(FB), DIMENSION(2) :: MINMAX
   LOGICAL :: TWO_BYTE
   REAL(EB):: SLICE_AGL
   LOGICAL :: TERRAIN_SLICE=.FALSE.,CELL_CENTERED=.FALSE., FIRE_LINE=.FALSE.
   CHARACTER(60) :: SMOKEVIEW_LABEL
   CHARACTER(30) :: SMOKEVIEW_BAR_LABEL
END TYPE SLICE_TYPE

TYPE BOUNDARY_FILE_TYPE
   INTEGER :: INDEX,PROP_INDEX,SPEC_INDEX=0,PART_INDEX=0
   CHARACTER(60) :: SMOKEVIEW_LABEL
   CHARACTER(30) :: SMOKEVIEW_BAR_LABEL
   LOGICAL :: CELL_CENTERED=.FALSE.
END TYPE BOUNDARY_FILE_TYPE

TYPE (BOUNDARY_FILE_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: BOUNDARY_FILE

TYPE ISOSURFACE_FILE_TYPE
   INTEGER :: INDEX=1,INDEX2=0,REDUCE_TRIANGLES=1,N_VALUES=1,SPEC_INDEX=0,SPEC_INDEX2=0,VELO_INDEX=0
   REAL(FB) :: VALUE(10)
   CHARACTER(60) :: SMOKEVIEW_LABEL,SMOKEVIEW_LABEL2
   CHARACTER(30) :: SMOKEVIEW_BAR_LABEL,SMOKEVIEW_BAR_LABEL2
END TYPE ISOSURFACE_FILE_TYPE

TYPE (ISOSURFACE_FILE_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: ISOSURFACE_FILE

TYPE PROFILE_TYPE
   REAL(EB) :: X,Y,Z
   INTEGER  :: IOR,IW,ORDINAL,MESH
   CHARACTER(30) :: ID,QUANTITY
END TYPE PROFILE_TYPE

TYPE (PROFILE_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: PROFILE

TYPE INITIALIZATION_TYPE
   REAL(EB) :: TEMPERATURE,DENSITY,MASS_FRACTION(MAX_SPECIES),X1,X2,Y1,Y2,Z1,Z2,MASS_PER_VOLUME,MASS_PER_TIME
   INTEGER  :: PART_INDEX=0,NUMBER_INITIAL_DROPLETS
   LOGICAL :: ADJUST_DENSITY=.FALSE., ADJUST_TEMPERATURE=.FALSE.
END TYPE INITIALIZATION_TYPE

TYPE (INITIALIZATION_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: INITIALIZATION

TYPE P_ZONE_TYPE
   REAL(EB) :: X1,X2,Y1,Y2,Z1,Z2
   REAL(EB), DIMENSION(0:MAX_LEAK_PATHS) :: LEAK_AREA
   CHARACTER(30) :: ID
END TYPE P_ZONE_TYPE

TYPE (P_ZONE_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: P_ZONE

TYPE MULTIPLIER_TYPE
   REAL(EB) :: DXB(6),DX0,DY0,DZ0
   INTEGER  :: I_LOWER,I_UPPER,J_LOWER,J_UPPER,K_LOWER,K_UPPER,N_LOWER,N_UPPER,N_COPIES
   CHARACTER(30) :: ID
   LOGICAL :: SEQUENTIAL=.FALSE.
END TYPE MULTIPLIER_TYPE

TYPE (MULTIPLIER_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: MULTIPLIER

TYPE FILTER_TYPE
   INTEGER :: RAMP_INDEX = -1, N_SPECIES
   CHARACTER(30) :: ID
   REAL(EB), DIMENSION(:), POINTER :: SPECIES_INDEX
   REAL(EB), DIMENSION(:), POINTER :: EFFICIENCY, MULTIPLIER
   REAL(EB) :: CLEAN_LOSS, LOSS_COEF
END TYPE FILTER_TYPE

TYPE (FILTER_TYPE), DIMENSION(:), ALLOCATABLE,  TARGET :: FILTER

TYPE DUCTNODE_TYPE
   INTEGER :: FILTER_INDEX=-1, N_DUCTS,VENT_INDEX = -1, MESH_INDEX = -1
   INTEGER, DIMENSION(:), POINTER :: DUCT_INDEX
   CHARACTER(30) :: ID,TABLE_ID,VENT_ID='null'
   REAL(EB), DIMENSION(:,:), POINTER :: LOSS_ARRAY
   REAL(EB), DIMENSION(:), POINTER :: YY, FILTER_LOADING, DIR, BRANCH_LOSS, YY_V
   REAL(EB) :: LOSS, P,TMP,RHO,MW,CP,XYZ(3),FILTER_LOSS,TMP_V,RHO_V,MW_V,CP_V
   LOGICAL :: UPDATED, FIXED, AMBIENT = .FALSE.
END TYPE DUCTNODE_TYPE

TYPE (DUCTNODE_TYPE), DIMENSION(:), ALLOCATABLE,  TARGET :: DUCTNODE

TYPE DUCT_TYPE
   INTEGER :: NODE_INDEX(2)=-1,DEVC_INDEX=-1,CTRL_INDEX=-1,FAN_INDEX=-1,AIRCOIL_INDEX=-1,RAMP_INDEX=-1
   REAL(EB) :: ROUGHNESS,LENGTH, DIAMETER, AREA_INITIAL, AREA, CP_D, RHO_D,TMP_D,LOSS(2)=0._EB,VEL(4)=0._EB,&
               DP_FAN=0._EB,TOTAL_LOSS = 0._EB,COIL_Q,VOLUME_FLOW=1.E6_EB,VOLUME_FLOW_INITIAL=1.E6_EB,X(2),Y(2),Z(2)
   REAL(EB), DIMENSION(:), POINTER :: YY
   LOGICAL :: ROUND = .TRUE.,SQUARE = .FALSE.,DAMPER = .FALSE.,DAMPER_OPEN = .TRUE.,FAN_OPERATING=.TRUE.,COIL_OPERATING=.TRUE.,&
              FIXED=.FALSE.,UPDATED
   CHARACTER(30) :: ID   
END TYPE DUCT_TYPE

TYPE (DUCT_TYPE), DIMENSION(:), ALLOCATABLE,  TARGET :: DUCT

TYPE FAN_TYPE
   INTEGER :: FAN_TYPE,RAMP_INDEX
   LOGICAL :: REVERSE=.FALSE.
   REAL(EB) :: VOL_FLOW,MAX_FLOW,MAX_PRES,OFF_LOSS=0._EB
   CHARACTER(30) :: ID,FAN_RAMP
END TYPE FAN_TYPE

TYPE(FAN_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: FAN

TYPE AIRCOIL_TYPE
   INTEGER :: DUCT_INDEX,CTRL_INDEX = -1, DEVC_INDEX = -1, COIL_TYPE
   REAL(EB) :: TMP_COOL, EFF, MDOT_COOL,FIXED_Q
   CHARACTER(30) :: ID
END TYPE AIRCOIL_TYPE

TYPE(AIRCOIL_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: AIRCOIL

TYPE NETWORK_TYPE
   INTEGER :: N_DUCTS,N_DUCTNODES,N_MATRIX
   INTEGER, DIMENSION(:), POINTER :: DUCT_INDEX,NODE_INDEX,MATRIX_INDEX
END TYPE NETWORK_TYPE

TYPE(NETWORK_TYPE), DIMENSION(:), ALLOCATABLE, TARGET :: NETWORK


CONTAINS

SUBROUTINE GET_REV_type(MODULE_REV,MODULE_DATE)
INTEGER,INTENT(INOUT) :: MODULE_REV
CHARACTER(255),INTENT(INOUT) :: MODULE_DATE

WRITE(MODULE_DATE,'(A)') typerev(INDEX(typerev,':')+1:LEN_TRIM(typerev)-2)
READ (MODULE_DATE,'(I5)') MODULE_REV
WRITE(MODULE_DATE,'(A)') typedate

END SUBROUTINE GET_REV_type

END MODULE TYPES
 
