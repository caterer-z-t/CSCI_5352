# In[1]: Imports

# Graph & Network Libraries
import networkx as nx
import igraph as ig

# Data Handling
import pandas as pd
import numpy as np
import random
import glob
import os
import re
from collections import deque
from itertools import combinations

# Plotting
import matplotlib.pyplot as plt
import seaborn as sns
from plotnine import *

# Statistical & Utility Libraries
from scipy.stats import zscore
from tqdm import tqdm
import time

# In[2]: Load Data

# Set the working directory to the directory of this file
os.chdir(os.path.dirname(os.path.abspath(__file__)))

# Load the Berkeley social network
uc_berkeley_filepath = "../hw1/facebook100txt/Berkeley13.txt"


def read_graph(filepath):
    """Reads the UC Berkeley social network from FB100 dataset."""
    G = nx.read_edgelist(filepath, nodetype=int, comments="id")
    return G

print("Reading UC Berkeley social network...")
berkeley_graph = read_graph(uc_berkeley_filepath)

# In[3]: Functions


def compute_metrics(graph):
    """Computes the clustering coefficient and avg shortest path using all shortest paths."""
    cluster_coefficient = nx.transitivity(graph)

    # Find the largest connected component
    largest_cc = max(nx.connected_components(graph), key=len)
    graph_cc = graph.subgraph(largest_cc).copy()

    # Use networkx's built-in average shortest path length function
    avg_shortest_path = nx.average_shortest_path_length(graph_cc)

    return cluster_coefficient, avg_shortest_path


def perform_double_edge_swaps(graph, r=1):
    """Performs r double-edge swaps on the graph."""
    return nx.double_edge_swap(
        graph, nswap=r, max_tries=r * 10
    )  # Increase max tries for feasibility


def plot_results_single_graph(metrics, reference_C, reference_L):
    """
    Creates a single plot with both clustering coefficient and average path length,
    using two y-axes for better visualization.

    Parameters:
    - metrics: DataFrame containing 'swaps', 'clustering', and 'path_length'
    - reference_C: Reference clustering coefficient
    - reference_L: Reference average path length
    """
    fig, ax1 = plt.subplots(figsize=(10, 6))

    # Normalize x-axis by number of edges
    x = np.array(metrics["swaps"])

    # Create a second y-axis
    ax2 = ax1.twinx()

    # Plot clustering coefficient on primary y-axis (left)
    ax1.semilogx(x, metrics["clustering"], "b-", label="Clustering Coefficient (C)")
    ax1.axhline(y=reference_C, color="b", linestyle="--", label="C (Config Model)")

    # Plot average path length on secondary y-axis (right)
    ax2.semilogx(x, metrics["path_length"], "g-", label="Avg Path Length (⟨ℓ⟩)")
    ax2.axhline(y=reference_L, color="g", linestyle="--", label="⟨ℓ⟩ (Config Model)")

    # Label axes
    ax1.set_xlabel("Number of swaps (r)")
    ax1.set_ylabel("Clustering Coefficient (C)", color="b")
    ax2.set_ylabel("Average Path Length (⟨ℓ⟩)", color="g")

    # Title
    plt.title("Evolution of Network Metrics under Randomization")

    # Grid
    ax1.grid(True)

    # Legends
    ax1.legend(loc="center left")
    ax2.legend(loc="upper right")

    return fig


# In[4]: Problem 3

# # Ensure the node list is converted to a sequence
# sampled_nodes = random.sample(
#     list(berkeley_graph.nodes), int(berkeley_graph.number_of_nodes() * 0.7)
# )

# # Create the sampled subgraph (must be a copy if modifying)
# sampled_graph = berkeley_graph.subgraph(sampled_nodes).copy()
print("Making a copy of the graph...")
sampled_graph = berkeley_graph.copy()

# Get number of edges (m)
m = sampled_graph.number_of_edges()

# Define steps logarithmically up to 20m
r_values = np.logspace(0, np.log10(20 * m), num=100, dtype=int)  # 10 log-spaced points
r_values = np.unique(r_values)  # Remove duplicates

print("Selected r values:", r_values)

# Storage for results
cluster_coeffs = []
avg_shortest_paths = []

print("Computing initial metrics...")
# Compute initial metrics
C_init, L_init = compute_metrics(sampled_graph)

# Store original graph
original_graph = sampled_graph.copy()

# Perform double-edge swaps at each r
for r in r_values:
    # Start fresh each time
    current_graph = original_graph.copy()
    current_graph = perform_double_edge_swaps(current_graph, r)
    C, L = compute_metrics(current_graph)

    cluster_coeffs.append(C)
    avg_shortest_paths.append(L)
    print(f"Completed {r} swaps. C={C:.4f}, L={L:.4f} \n")


fig = plot_results_single_graph(
    pd.DataFrame(
        {
            "swaps": r_values,
            "clustering": cluster_coeffs,
            "path_length": avg_shortest_paths,
        }
    ),
    cluster_coeffs[-1],
    avg_shortest_paths[-1],
)
print("Saving figure...")
plt.savefig("figures/network_evolution.png")
