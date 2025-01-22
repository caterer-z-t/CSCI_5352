# 2025 - 01 - 21

networks are a model and a representation of complexity of a system

understanding how a system as a whole behaves

list of compopnents = nodes

interactions = edges

two nodes connected via an edge is a pairwise interactions

defining a network

set notation

    G = (V,E)
    E is a subset of VxV
    (i,j) is in E
    i, j is in V

adjacency matrix

    n by n matrix
    n = |V|
    m = |E|

    A_{ij} = {1 if (i,j) in E, else 0} is cell

most basic kind of network

Simple Graph
    1. edges are undirected ==> A_{ij} = 1 = A_{ji}
    2. eges are unweighted ==> A_{ij} in (0, 1)
    3. no self - loops ==> for all A_{i} A_{ii} = 0
    4. no annotations on nodes or edges

adjacency matrix is great for mathematics 

- space: $\Theta(n^{2})$
- real world networks are sparce ==> m = O(n)
- cannot use these for large networks

adjacency list - squeezes out the zeros

- only stores the edge set
- 1st vector of the nodes, then off each node store the adajacencies
- space $\Theta(n + m)$

edge list - list just the pairs

- space: $\Theta(m)$
- horrible idea b/c cannot represent nodes of degree 0
- cannot tell the difference between node indicieis

edges:
    signed = +1 / -1 / 0 (special case of weighted graph)

    multigraph - multiple edges between the same nodes

nodes:
    
    - metadata
    
    - locations or coordinates

    - state variables

network types:
    
    - sparse

    - dense

    - bipartite

    - projection

    - connected

    - disconnected

    - acyclic

    - temporal

    - multiplex 

    - hypergraph

directed graphs:

$(i,j) \in E$

$(j,i) \notin E$

types:
1. Directed acyclic graph (dag) -- underline ordering (no backflow)
2. directed graph (digraph) -- no underline directionality

feedforward loop (dag)

feedback loop -- traditional loop we think of

bipartite networks:

$V = {V_1, V_2} \text{ for } (i,j) \in E$

While $i \in V_1 \text{ and } j \in V_2$

one mode projection: changing what we define as nodes and edges

connected (one component) vs disconnected (multiple components): 

component = set of reachable verticies

1. undirected: pairwise reachable
2. directed: pairewise reachable "strongly connected", from i -> j but not j -> i then "weakly connected"

path: sequence of edges with no verticies repeated

pathlength = # of edges in that sequence


# 2025 - 01 - 16

ethics and networks
- 0 edges = non-independence
1. networks are maps
    maps = power of visibility = see every interactions
2. networks leek information
    homophology = the tendency of people to associate with others who are similar to them
    can use this imperical pattern which can be a problem which is context dependent
3. networks are re-identifiable
    a. leakage
        if remove all atributes, and just have topology, you can still recover the information
    b. structure

# 2025 - 01 - 14

two fundamental questions to form a network
1. what is a vertex -- a set of distinct objects
2. when are two verticies connected -- pairwise relationships

project idea's 
----
maybe looking at the relationship between tb drug treatment and patient outcome


