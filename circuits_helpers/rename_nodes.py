# Reads circuit in mrewiens format.
# Outputs equivalent circuit with nodes numerated from 1 to N.
# Pre-processing step for easier processing in MATLAB.

seen = set()
with open("edges.txt") as f:
    for l in f:
        node1, node2 = l.split()
        seen.add(int(node1))
        seen.add(int(node2))

mapping = {v: str(i) for i, v in enumerate(seen, start=1)}

with open("edges.txt") as src, open("out_edges.txt", "w") as dst:
    for l in src:
        node1, node2 = (int(s) for s in l.split())
        if node1 not in seen or node2 not in seen:
            continue
        dst.write(str(mapping[node1]))
        dst.write(" ")
        dst.write(str(mapping[node2]))
        dst.write("\n")

with open("vert.txt") as src, open("out_term.txt", "w") as dst:
    for l in src:
        term = int(l)
        try:
            dst.write(mapping[term])
            dst.write("\n")
        except KeyError:
            pass

with open("out_mapping.txt", "w") as f:
    for m, t in mapping.items():
        f.write(str(m))
        f.write(str(" "))
        f.write(t)
        f.write("\n")
