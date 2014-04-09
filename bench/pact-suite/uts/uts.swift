import io;
import sys;

// TODO: UTS params?
typedef tree_t int;
global const tree_t TREE_BIN = 0;
global const tree_t TREE_GEO = 1;
global const tree_t TREE_HYBRID = 2;
global const tree_t TREE_BALANCED = 3;

typedef geoshape_t int;
global const geoshape_t GEO_LINEAR = 0;
global const geoshape_t EXPDEC = 1;
global const geoshape_t CYCLIC = 2;
global const geoshape_t FIXED = 3;

// Represent as string
type uts_node string;

(uts_node node) uts_root(tree_t tree_type, int root_id) "uts" "0.0" [
  "set <<node>> [ uts::uts_root <<tree_type>> <<root_id>> ]"
];

/*
 * Run uts for a period on the worker.
 * depth_first: do depth first search (otherwise breadth-first)
 * max_nodes: max unprocessed nodes to accumulate on run
 * max_steps: max number of nodes to process
 */
@dispatch=WORKER
(uts_node desc_nodes[]) uts_run(uts_node node, tree_t tree_type,
    geoshape_t geoshape, int gen_mx, float shift_depth,
    boolean depth_first, int max_nodes, int max_steps)
    "uts" "0.0" [
    "set <<desc_nodes>> [ uts::uts_run <<node>> <<tree_type>> <<geoshape>> <<gen_mx>> <<shift_depth>> <<max_nodes>> <<max_steps>>] "
];

main {
  // TODO: missing some geo params
  // TODO: select params?
  tree_t tree_type = TREE_GEO;
  geoshape_t geo_shape = GEO_LINEAR;
  float shift_depth = 0.5;

  argv_accept("root_id", "gen_mx", "max_nodes", "max_steps");

  printf("Swift/T UTS") =>
    printf("args: %s", args()) =>
    printf("tree_type: %i geo_shape: %i shift_depth: %f",
          tree_type, geo_shape, shift_depth);
  int root_id = toint(argv("root_id", "0"));
  int gen_mx = toint(argv("gen_mx", "6"));
  int max_nodes = toint(argv("max_nodes", "1024"));
  int max_steps = toint(argv("max_steps", "10000"));


  uts_node root = uts_root(tree_type, root_id);

  // first generate a bunch of parallel work
  uts_node nodes1[] = uts_run(root, tree_type, geo_shape, gen_mx, shift_depth,
                          false, max_nodes, 256);
  foreach n1 in nodes1 {
    uts_node nodes2[] = uts_run(n1, tree_type, geo_shape, gen_mx, shift_depth,
                          false, max_nodes, 256);
    foreach n2 in nodes2 {
      uts_rec(n2, tree_type, geo_shape, shift_depth, gen_mx, max_nodes, max_steps);
    }
  }
}

uts_rec(uts_node node, tree_t tree_type, geoshape_t geo_shape, float shift_depth,
        int gen_mx, int max_nodes, int max_steps) {

  uts_node nodes[] = uts_run(node, tree_type, geo_shape, gen_mx, shift_depth,
                             true, max_nodes, max_steps);
  foreach node2 in nodes {
    uts_rec(node2, tree_type, geo_shape, shift_depth, gen_mx,
            max_nodes, max_steps);
  }
}

