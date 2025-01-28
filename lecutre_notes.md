# 2025 - 01 - 28

motif's - 

clustering coefficent is a network level analysis $\in [0,1]$ -> aka transitivity

$= \frac{\frac{1}{3} Tr(A^3)}{ \sum_{i != j }A_{ij}^2}$

social networks have higher Clustering coefficients than non-social networks -> triadic closure

local clustering coefficient (node level measuremient) $C_i$ - how locally dense is my neighborhood. 

$C_i = \frac{# triangle}{# of triad} = what fraction of my friends are friends with eachother = \frac{# connections amoung my friends}{k_i \choose 2}$

$C_i \in [0,1]$ 

$\langle C_i \rangle = \frac{1}{n}\sum_{i=1}^n C_i \neq C$

larger motifs:  
    $n=4 (cube) = Q = number of motifs / expeted number of motifs, \quad \in [0,+\inf]$

    motifs kind of stop at three due to the need to change the motif and definition based on circumstance

network positional measures - measure of distance or paths. 

path: possible to have short heavy path (edges with weights) or long light (low edge weights) path, two different quantitites

length of the shortest path - can be multiple shortest paths

if network is disconnected then the pathlength is inifinity if trying to traverse between disconnected nodes

diameters is length max such that it is not infinity -- network level measure

eccentricity: longest path you can take from i to j  -- node level statistic

mean geodesic distance (MGD) $<l> = \frac{1}{z}\sum_{ij}(l_{ij} \neq \inf)$ where z is the number of non inf entries in l matrix




# 2025 - 01 - 23

multilayer networks -- common for different types of edges (colors - categorical variables -- no ordering but distinct)
- special case are temporal (in time), snapshots networks in time

describe and summarize networks 

(there are network and node level measures of each of these)
## 
1. connectivitiy ->
    adjacent nodes -> measure of immediate neighborhoods -> how many connections does some node $i$ have?

2. motif ->
    small subgraphs (graphlets) w/ some meaning -> participation / frequency occur in network

3. positional ->
    where in the network does a node sit?

## 

node degree: 1st order measure of network structure

simple graph: $k_i = \sum{_j=1}^{n} A_{ij} =  \sum{_j=1}^{n} A_{ji}$ b/c $A_{ij} = A_{ji}$

weighted edges: node strength = $s_i = \sum_{j=1}^{n} A_{ij}$ since weighted edge

number of edges(unweighted): $m = \frac{1}{2}\sum_{i=1}^{n} k_i = \frac{1}{2}\sum_{i=1}^{n} \sum_{j=1}^{n} A_{ij} = \text{matrix sum} = \sum_{i=1}^{n}\sum_{j>i}^{n} A_{ij}$

mean degree: $<k> = \frac{1}{n}\sum_{i=1}^{n} k_i = \frac{2m}{n}$

connectance (or density) $e = \frac{m}{n \choose 2} = \frac{2m}{n(n-1)} = \frac{<k>}{n-1}$

directed networks node level

identity $k in mean = k out mean$

in degree -- follower count = $k_{i}^{in} = \sum_{j=1}^{n} A_{ji}$

out degree -- following count = $k_{i}^{out} = \sum_{j=1}^{n} A_{ij}$

total degree = $k_{i}^{tot} = \sum_{j=1}^{n} A_{ji} \vee \sum_{j=1}^{n} A_{ij} $ (note this is or operator)

degree sequence = $[k_1, k_2, k_3, ... k_n]$

degree distribution = histogram of degree sequence
$$Pr(k) = (1/6, 3/6, 1/6, 1/6, 0,...)$$

most real world networks have a heavy-tailed degree distribution -- highly skewed

log of y axis - see more variance in body of distribution and early tail 

log log plot - 'power law' $P(k) \propto k^{-\alpha}, \quad \text{for } \alpha > 1$

$logPr(k) \propto -\alpha \times log(k)$

## n=2

smallest motif of size 2 (in a directed network) - either reciprocated or unreciprocated

reciprocity: (only directed nets)

network level $n = \frac{1}{m} \sum_{ij}A_{ij}A_{ji} \text{ for, r} \in [0,1]$

node level $r_i = \frac{1}{k_{i}^{out}}\sum_{j}A_{ij}A_{ji}$

## n=3

clustering coefficient = motif of size 3

triangle density

for every connected triple do we have a triangle?

$C = \frac{(\text{number of trianlges}) \times 3}{(\text{number of connected triples})} = \frac{\sum_{i=1}^{n}\sum_{j=1}^{n}\sum_{k=1}^{n}A_{ij}A_{jk}A_{ki}}{\sum_{i=1}^{n}\sum_{j=1}^{n}\sum_{k=1}^{n}A_{ij}A_{jk}}$

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


