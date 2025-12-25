[Mesh]
  file = ../mesh.msh
  construct_node_list_from_side_list = true

[]
# [gen]
  # type = FileMeshGenerator
  # file = ../mesh.e
# []
# [gen2]
#   type = BlockDeletionGenerator
#   input = gen
#   block = dammy
# []
