"""
	#~ Plot a snapshot of a good web graph/network.
	
	#~ Needs: Ajacency list of who eats whom (consumer name/in in 1st
	#~ column, resource name/id in 2nd column), and list of species names
	#~ /ids and proprerties such as node abundance or average mass
"""

import networkx as nx
import scipy as sc
import matplotlib.pyplot as plt
# import matplotlib.animation as ani #for animation

def GenRdmAdjList (N = 2, C = 0.1):
	"""
	Generate random adjacency list given N nodes with connectance
	probability C
	"""
	Ids = range(N)
	ALst = []
	for i in Ids:
		if sc.random.uniform(0,1,1) < C:
			Lnk = sc.random.choice(Ids,2).tolist()
			if Lnk[0] != Lnk[1]: #avoids self loops
				ALst.append(Lnk)
	return ALst
	
## Assign body mass range
SizRan = ([-10,10]) #use log scale

## Assign number of species (MaxN) and connectance (C)
MaxN= 30
C = 0.75

## Generate adjacency list:
AdjL = sc.array(GenRdmAdjList(MaxN, C))

## Generate species (node) data:
Sps = sc.unique(AdjL)
Sizs = sc.random.uniform(SizRan[0],SizRan[1],MaxN) # Generate body sizes (log 10 scale)

##### The Plotting ######
plt.close('all')

##Plot using networkx:

## Calculate co-ordinates for circular configuration:
## (See networkx.layout for inbuilt fncitons to compute other types of node
# coords)

pos = nx.circular_layout(Sps)

G = nx.Graph()
G.add_nodes_from(Sps)
G.add_edges_from(tuple(AdjL))
NodSizs= 10**-32 + (Sizs-min(Sizs))/(max(Sizs)-min(Sizs)) 
# Node sizes in proportion to body sizes
nx.draw(G, pos, node_size = NodSizs*1000)
plt.show()

