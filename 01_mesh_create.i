[Mesh]
  type = MeshGeneratorMesh

  # --- 1) 3D mesh 読み込み ---
  [base]
    type = FileMeshGenerator
    file = mesh.e
  []

  # --- 2) sideset 'frac' から 2D fracture block を作成 ---
  [frac]
    type = LowerDBlockFromSidesetGenerator
    input = base
    sidesets = 'frac'          # mesh.e にある fracture の sideset 名/ID
    new_block_id = 20
    new_block_name = 'frac'
  []
  []
